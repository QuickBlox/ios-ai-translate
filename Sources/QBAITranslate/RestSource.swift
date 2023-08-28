//
//  RestSource.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

/// Represents the settings used for OpenAI model requests.
public struct OpenAIRequestSettings {
    /// The API version to be used for OpenAI requests.
    public var apiVersion: APIVersion = .v1
    
    /// Optional organization information for OpenAI requests.
    public var organization: String?
}

/// Represents the body settings used for OpenAI model requests.
public struct OpenAIBodySettings {
    /// The model to be used for generating responses (e.g., gpt-3.5-turbo, gpt-4, etc.).
    public var model: GPTModel = .gpt3_5_turbo
    
    /// The temperature setting for generating responses (higher values make output more random).
    public var temperature: Float = 0.5
    
    /// The maximum number of tokens to generate in the response.
    public var maxTokens: Int?
}

/// Represents the overall settings used for OpenAI model requests
public struct OpenAISettings {
    /// The request settings for OpenAI.
    public var request: OpenAIRequestSettings = OpenAIRequestSettings()
    
    /// The body settings for OpenAI.
    public var body: OpenAIBodySettings = OpenAIBodySettings()
}

/// Represents the available API versions for OpenAI.
public enum APIVersion: String {
    case v1
}

/// Represents the available GPT models for OpenAI.
public enum GPTModel: String {
    case gpt3_5_turbo = "gpt-3.5-turbo"
    case gpt3_5_turbo_0613 = "gpt-3.5-turbo-0613"
    case gpt3_5_turbo_16k = "gpt-3.5-turbo-16k"
    case gpt3_5_turbo_16k_0613 = "gpt-3.5-turbo-16k-0613"
    
    case gpt4 = "gpt-4"
    case gpt4_0613 = "gpt-4-0613"
    case gpt4_32k = "gpt-4-32k"
    case gpt4_32k_0613 = "gpt-4-32k-0613"
}

/// Represents the possible exceptions that can be thrown by the RestSourceProtocol methods.
public enum RestSourceException: Error {
    /// Thrown when the URL is invalid.
    case invalidURL
    /// Thrown when the request body is incorrect.
    case wrongBody
    /// Thrown when the choices in the response are incorrect.
    case wrongChoices
    /// Thrown when the choices in the response are empty.
    case emptyChoices
    /// Thrown when the message in the response is incorrect.
    case wrongMessage
    /// Thrown when the content in the response is incorrect.
    case wrongContent
}

/// Represents the protocol for making RESTful API calls to OpenAI.
public protocol RestSourceProtocol {
    func requestOpenAI(translate text: String,
                       language: String,
                       key: String,
                       apply settings: OpenAISettings) async throws -> String
    
    func requestOpenAI(translate text: String,
                       language: String,
                       token: String,
                       proxy urlPath: String,
                       apply settings: OpenAISettings) async throws -> String
    
}

/// Represents the default implementation of RestSourceProtocol using URLSession to make API requests to OpenAI.
open class RestSource: RestSourceProtocol {
    public func requestOpenAI(translate text: String,
                              language: String,
                              key: String,
                              apply settings: OpenAISettings) async throws -> String {
        let body = try httBody(with: text,
                               language: language,
                               settings: settings.body)
        
        let request = try openAIRequest(key: key,
                                        body: body,
                                        settings: settings.request)
        
        return try await responseAnswer(with: request)
    }
    
    public func requestOpenAI(translate text: String,
                              language: String,
                              token: String,
                              proxy urlPath: String,
                              apply settings: OpenAISettings) async throws -> String {
        let body = try httBody(with: text,
                               language: language,
                               settings: settings.body)
        
        let request = try openAIProxyRequest(token: token,
                                             server: urlPath,
                                             body: body,
                                             settings: settings.request)
        
        return try await responseAnswer(with: request)
    }
    
    
    private func openAIProxyRequest(token: String,
                                    server urlPath: String,
                                    body: Data,
                                    settings: OpenAIRequestSettings) throws -> URLRequest {
        let path = "\(settings.apiVersion)/chat/completions"
        let fullPath = "\(urlPath)/\(path)"
        
        guard let url = URL(string: fullPath) else {
            throw RestSourceException.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        if let organization = settings.organization,
           organization.isEmpty == false {
            request.setValue("organization",
                             forHTTPHeaderField: "OpenAI-Organization")
        }
        
        request.setValue(token,
                         forHTTPHeaderField: "QB-Token")
        
        request.httpBody = body
        
        return request
    }
    
    private func openAIRequest(key: String,
                               body: Data,
                               settings: OpenAIRequestSettings) throws -> URLRequest {
        let domain = "api.openai.com"
        let path = "\(settings.apiVersion)/chat/completions"
        let fullPath = "https://\(domain)/\(path)"
        
        guard let url = URL(string: fullPath) else {
            throw RestSourceException.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        if let organization = settings.organization,
           organization.isEmpty == false {
            request.setValue("organization",
                             forHTTPHeaderField: "OpenAI-Organization")
        }
        
        request.httpBody = body
        
        return request
    }
    
    private func responseAnswer(with request: URLRequest) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            
            var reason = "Invalid response"
            if let description = try? JSONSerialization.jsonObject(with: data, options: []) {
                reason = "Invalid response. \r\(description)"
            }
            
            throw NSError(domain: reason,
                          code: httpResponse.statusCode,
                          userInfo: nil)
        }
        
        
        return try parseAnswer(from: data)
    }
    
    private func httBody(with text: String,
                         language: String,
                         settings: OpenAIBodySettings) throws -> Data {
        var httpBody: [String: Any] = [
            "model": settings.model.rawValue,
            "temperature": settings.temperature
        ]
        
        if let maxToken = settings.maxTokens, maxToken > 0 {
            httpBody["max_tokens"] = maxToken
        }
        
        var json: [[String: String]] = []
        let userJson = [
            "role": "user",
            "content": "Translate the following text to \(language): {\(text)}"
        ]
        json.append(userJson)
        
        httpBody["messages"] = json
        
        return try JSONSerialization.data(withJSONObject: httpBody)
    }
    
    private func parseAnswer(from body: Data) throws -> String {
        guard let json = try JSONSerialization.jsonObject(with: body, options: []) as? [String: Any] else {
            throw RestSourceException.wrongBody
        }
        
        guard let choices = json["choices"] as? [Any] else {
            throw RestSourceException.wrongChoices
        }
        
        guard let first = choices[0] as? [String: Any] else {
            throw RestSourceException.emptyChoices
        }
        
        guard let message = first["message"] as? [String: Any] else {
            throw RestSourceException.wrongMessage
        }
        
        guard let content = message["content"] as? String else {
            throw RestSourceException.wrongContent
        }
        
        return content
    }
}
