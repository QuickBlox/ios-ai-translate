//
//  RestSource.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

/// Represents the possible exceptions that can be thrown by the module methods.
public enum QBAIException: Error {
    /// Thrown when the provided token has an incorrect value.
    case incorrectToken
    /// Thrown when the server URL has an incorrect value.
    case incorrectProxyServerUrl
    /// Thrown when the provided text tokens count has an incorrect value.
    case incorrectTokensCount
    /// Thrown when the URL is invalid.
    case invalidURL
    /// Thrown when the response body is incorrect.
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
    func request<M, S>(translate text: String,
                       with messages: [M],
                       using settings: S) async throws -> String
    where M: Message, S: Settings
}

/// Represents the default implementation of RestSourceProtocol using URLSession to make API requests to OpenAI.
open class RestSource: RestSourceProtocol {
    public func request<M, S>(translate text: String,
                              with messages: [M],
                              using settings: S) async throws -> String
    where M: Message, S: Settings {
        let body = try httpbody(with: text,
                               history: messages, 
                               and: settings)
        let request = try request(with: body, using: settings)
        
        return try await responseAnswer(with: request)
    }
    
    private func request<S>(with body: Data, using settings: S)
    throws -> URLRequest where S: Settings {
        let path = "\(settings.apiVersion)/chat/completions"
        var url: URL?
        
        if ServerUrlValidator.isNotCorrect(settings.serverPath) == false,
            settings.token.isCorrect {
            url = URL(string:"\(settings.serverPath)/\(path)")
        } else if settings.apiKey.isCorrect {
            url = URL(string: "https://api.openai.com/\(path)")
        } else {
            if ServerUrlValidator.isNotCorrect(settings.serverPath) {
                throw QBAIException.incorrectProxyServerUrl
            } else {
                throw QBAIException.incorrectToken
            }
        }
        
        guard let url = url else {
            throw QBAIException.invalidURL
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
        
        if settings.serverPath.isCorrect {
            request.setValue(settings.token, forHTTPHeaderField: "QB-Token")
        } else {
            request.setValue("Bearer \(settings.apiKey)",
                              forHTTPHeaderField: "Authorization")
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
    
    private func httpbody<M, S>(with text: String,
                               history messages: [M],
                               and settings: S) throws -> Data 
    where M: Message, S: Settings {
        var httpBody: [String: Any] = [
            "model": settings.model.rawValue,
            "temperature": settings.temperature
        ]
        
        if let maxTokens = settings.maxResponseTokens, maxTokens > 0 {
            httpBody["max_tokens"] = maxTokens
        }
        
        var json: [[String: String]] = []
        for message in messages {
            json.append(parse(message))
        }
        
        json.append(prompt(with: text, and: settings.language))
        
        print(json)
        
        httpBody["messages"] = json
        
        return try JSONSerialization.data(withJSONObject: httpBody)
    }
    
    private func prompt(with text: String, and language: Language) -> [String: String] {
        let languageName = language.locale.localizedLanguageName
        
        let prompt = "Translate the provided text in \(languageName) language and only return the translated text. If the translation fails or is not possible for any reason, only return 'Translation failed'. Text to be translated is: \"\(text)\"."
        
        return ["role": "user", "content": prompt]
    }
    
    private func parse<M>(_ message: M) -> [String: String] 
    where M: Message {
        switch message.role {
        case .me: return parse(my: message.text)
        case .other: return parse(other: message.text)
        }
    }
    
    private func parse(other message: String) -> [String: String] {
        return ["role": "assistant", "content": message]
    }
    
    private func parse(my message: String) -> [String: String] {
        return ["role": "user", "content": message]
    }
    
    private func parseAnswer(from body: Data) throws -> String {
        guard let json = try JSONSerialization.jsonObject(with: body, options: []) as? [String: Any] else {
            throw QBAIException.wrongBody
        }
        
        guard let choices = json["choices"] as? [Any] else {
            throw QBAIException.wrongChoices
        }
        
        guard let first = choices[0] as? [String: Any] else {
            throw QBAIException.emptyChoices
        }
        
        guard let message = first["message"] as? [String: Any] else {
            throw QBAIException.wrongMessage
        }
        
        guard let content = message["content"] as? String else {
            throw QBAIException.wrongContent
        }
        
        return content
    }
}

/// Extension to provide a utility method to check if a string is not correct by removing whitespaces and newlines from both ends and checking if the resulting string is empty.
extension String {
    var isCorrect: Bool {
        // Remove whitespaces and newlines from both ends of the string
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        // Check if the resulting string is empty
        return trimmedString.isEmpty == false
    }
}
