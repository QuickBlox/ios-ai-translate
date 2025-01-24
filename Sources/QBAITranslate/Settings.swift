//
//  Settings.swift
//
//  Created by Injoit on 22.09.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

public protocol Settings {
    /// The current `Language` language.
    var language: Language { get set }
    /// The API key to be used for making the request to OpenAI.
    var apiKey: String { get set }
    /// The user token used for proxy communication.
    var token: String { get set }
    /// The proxy URL to be used for making the request to OpenAI.
    /// Using a proxy server like the [QuickBlox AI Assistant Proxy Server](https:github.com/QuickBlox/qb-ai-assistant-proxy-server) offers significant benefits in terms of security and functionality:
    var serverPath: String { get set }
    /// The API version to be used for OpenAI requests.
    var apiVersion: APIVersion { get set }
    /// Optional organization information for OpenAI requests.
    var organization: String? { get set }
    /// The `Model` to be used for generating responses (e.g., gpt-3.5-turbo, gpt-4, etc.).
    var model: Model { get set }
    /// The temperature setting for generating responses (higher values make output more random).
    var temperature: Float { get set }
    /// The maximum number of tokens to generate in the request.
    var maxRequestTokens: Int { get set }
    /// The maximum number of tokens to generate in the response.
    var maxResponseTokens: Int? { get set }
    
    /// - Parameters:
    ///   - apiKey: The API key to be used for making the request to OpenAI.
    ///   - language: The `Language` to be used for making the request to OpenAI.
    ///   - apiVersion: The API version to be used for OpenAI requests.
    ///   - organization: Optional organization information for OpenAI requests.
    ///   - model: The `Model` to be used for generating responses (e.g., gpt-3.5-turbo, gpt-4, etc.).
    ///   - temperature: The temperature setting for generating responses (higher values make output more random).
    ///   - maxRequestTokens: The maximum number of tokens to generate in the request.
    ///   - maxResponseTokens: The maximum number of tokens to generate in the response.
    init(apiKey: String,
         language: Language,
         apiVersion: APIVersion,
         organization: String?,
         model: Model,
         temperature: Float,
         maxRequestTokens: Int,
         maxResponseTokens: Int?)
    
    /// Using a proxy server like the [QuickBlox AI Assistant Proxy Server](https:github.com/QuickBlox/qb-ai-assistant-proxy-server) offers significant benefits in terms of security and functionality:
    ///
    /// Enhanced Security:
    /// - When making direct requests to the OpenAI API from the client-side, sensitive information like API keys may be exposed. By using a proxy server, the API keys are securely stored on the server-side, reducing the risk of unauthorized access or potential breaches.
    /// - The proxy server can implement access control mechanisms, ensuring that only authenticated and authorized users with valid QuickBlox user tokens can access the OpenAI API. This adds an extra layer of security to the communication.
    ///
    /// Protection of API Keys:
    ///  - Exposing API keys on the client-side could lead to misuse, abuse, or accidental exposure. A proxy server hides these keys from the client, mitigating the risk of API key exposure.
    ///  - Even if an attacker gains access to the client-side code, they cannot directly obtain the API keys, as they are kept confidential on the server.
    ///
    ///  Rate Limiting and Throttling:
    ///  - The proxy server can enforce rate limiting and throttling to control the number of requests made to the OpenAI API. This helps in complying with API usage policies and prevents excessive usage that might lead to temporary or permanent suspension of API access.
    ///
    ///  Request Logging and Monitoring:
    ///  - By using a proxy server, requests to the OpenAI API can be logged and monitored for auditing and debugging purposes. This provides insights into API usage patterns and helps detect any suspicious activities.
    ///
    ///  Flexibility and Customization:
    ///  - The proxy server acts as an intermediary, allowing developers to introduce custom functionalities, such as response caching, request modification, or adding custom headers. These customizations can be implemented without affecting the client-side code.
    ///
    ///  SSL/TLS Encryption:
    ///  - The proxy server can enforce SSL/TLS encryption for data transmission between the client and the server. This ensures that data remains encrypted and secure during communication.
    ///
    /// - Parameters:
    ///   - token: The user token used for proxy communication.
    ///   - serverPath: The proxy URL to be used for making the request to OpenAI.
    ///   - language: The `Language` to be used for making the request to OpenAI.
    ///   - apiVersion: The API version to be used for OpenAI requests.
    ///   - organization: Optional organization information for OpenAI requests.
    ///   - model: The `Model` to be used for generating responses (e.g., gpt-3.5-turbo, gpt-4, etc.).
    ///   - temperature: The temperature setting for generating responses (higher values make output more random).
    ///   - maxRequestTokens: The maximum number of tokens to generate in the request.
    ///   - maxResponseTokens: The maximum number of tokens to generate in the
    init(token: String,
         serverPath: String,
         language: Language,
         apiVersion: APIVersion,
         organization: String?,
         model: Model,
         temperature: Float,
         maxRequestTokens: Int,
         maxResponseTokens: Int?)
}

public struct Default {
    public static var language: Language = .english
    public static var apiVersion: APIVersion = .v1
    public static var model: Model = .gpt4o_mini
    public static var temperature: Float = 0.5
    public static var maxRequestTokens: Int = 3000
}

public struct AISettings: Settings {
    /// The current `Language` language. Default `.english`.
    public var language: Language = Default.language
    /// The API key to be used for making the request to OpenAI.
    public var apiKey: String = ""
    /// The user token used for proxy communication.
    public var token: String = ""
    /// The proxy URL to be used for making the request to OpenAI.
    /// Using a proxy server like the [QuickBlox AI Assistant Proxy Server](https:github.com/QuickBlox/qb-ai-assistant-proxy-server) offers significant benefits in terms of security and functionality:
    public var serverPath: String = ""
    /// The `APIVersion` to be used for OpenAI requests. Default `.v1`.
    public var apiVersion: APIVersion = Default.apiVersion
    /// Optional organization information for OpenAI requests.
    public var organization: String? = nil
    /// The `Model` to be used for generating responses (e.g., gpt-3.5-turbo, gpt-4, etc.). Default `.gpt3_5_turbo`
    public var model: Model = Default.model
    /// The temperature setting for generating responses (higher values make output more random). Default `0.5`.
    public var temperature: Float = Default.temperature
    /// The maximum number of tokens to generate in the request. Default `\(Default.maxRequestTokens)`.
    public var maxRequestTokens: Int = Default.maxRequestTokens
    /// The maximum number of tokens to generate in the response.
    public var maxResponseTokens: Int? = nil
    
    private init() { }
    
    /// - Parameters:
    ///   - apiKey: The API key to be used for making the request to OpenAI.
    ///   - language: The `Language` to be used for making the request to OpenAI.
    ///   - apiVersion: The API version to be used for OpenAI requests.
    ///   - organization: Optional organization information for OpenAI requests.
    ///   - model: The `Model` to be used for generating responses (e.g., gpt-3.5-turbo, gpt-4, etc.).
    ///   - temperature: The temperature setting for generating responses (higher values make output more random).
    ///   - maxRequestTokens: The maximum number of tokens to generate in the request.
    ///   - maxResponseTokens: The maximum number of tokens to generate in the response.
    public init(apiKey: String,
         language: Language,
         apiVersion: APIVersion = Default.apiVersion,
         organization: String? = nil,
         model: Model = Default.model,
         temperature: Float = Default.temperature,
         maxRequestTokens: Int = Default.maxRequestTokens,
         maxResponseTokens: Int? = nil) {
        self.apiKey = apiKey
        self.language = language
        self.apiVersion = apiVersion
        self.organization = organization
        self.temperature = temperature
        self.maxRequestTokens = maxRequestTokens
        self.maxResponseTokens = maxResponseTokens
    }
    
    /// Using a proxy server like the [QuickBlox AI Assistant Proxy Server](https:github.com/QuickBlox/qb-ai-assistant-proxy-server) offers significant benefits in terms of security and functionality:
    ///
    /// Enhanced Security:
    /// - When making direct requests to the OpenAI API from the client-side, sensitive information like API keys may be exposed. By using a proxy server, the API keys are securely stored on the server-side, reducing the risk of unauthorized access or potential breaches.
    /// - The proxy server can implement access control mechanisms, ensuring that only authenticated and authorized users with valid QuickBlox user tokens can access the OpenAI API. This adds an extra layer of security to the communication.
    ///
    /// Protection of API Keys:
    ///  - Exposing API keys on the client-side could lead to misuse, abuse, or accidental exposure. A proxy server hides these keys from the client, mitigating the risk of API key exposure.
    ///  - Even if an attacker gains access to the client-side code, they cannot directly obtain the API keys, as they are kept confidential on the server.
    ///
    ///  Rate Limiting and Throttling:
    ///  - The proxy server can enforce rate limiting and throttling to control the number of requests made to the OpenAI API. This helps in complying with API usage policies and prevents excessive usage that might lead to temporary or permanent suspension of API access.
    ///
    ///  Request Logging and Monitoring:
    ///  - By using a proxy server, requests to the OpenAI API can be logged and monitored for auditing and debugging purposes. This provides insights into API usage patterns and helps detect any suspicious activities.
    ///
    ///  Flexibility and Customization:
    ///  - The proxy server acts as an intermediary, allowing developers to introduce custom functionalities, such as response caching, request modification, or adding custom headers. These customizations can be implemented without affecting the client-side code.
    ///
    ///  SSL/TLS Encryption:
    ///  - The proxy server can enforce SSL/TLS encryption for data transmission between the client and the server. This ensures that data remains encrypted and secure during communication.
    ///
    /// - Parameters:
    ///   - token: The user token used for proxy communication.
    ///   - serverPath: The proxy URL to be used for making the request to OpenAI.
    ///   - language: The `Language` to be used for making the request to OpenAI.
    ///   - apiVersion: The API version to be used for OpenAI requests.
    ///   - organization: Optional organization information for OpenAI requests.
    ///   - model: The `Model` to be used for generating responses (e.g., gpt-3.5-turbo, gpt-4, etc.).
    ///   - temperature: The temperature setting for generating responses (higher values make output more random).
    ///   - maxRequestTokens: The maximum number of tokens to generate in the request.
    ///   - maxResponseTokens: The maximum number of tokens to generate in the response.
    public init(token: String,
         serverPath: String,
         language: Language,
         apiVersion: APIVersion = Default.apiVersion,
         organization: String? = nil,
         model: Model = Default.model,
         temperature: Float = Default.temperature,
         maxRequestTokens: Int = Default.maxRequestTokens,
         maxResponseTokens: Int? = nil) {
        self.token = token
        self.serverPath = serverPath
        self.language = language
        self.apiVersion = apiVersion
        self.organization = organization
        self.temperature = temperature
        self.maxRequestTokens = maxRequestTokens
        self.maxResponseTokens = maxResponseTokens
    }
}

/// Represents the available API versions for OpenAI.
public enum APIVersion: String {
    case v1
}

/// Represents the available GPT models for OpenAI.
public enum Model: String {
    @available(*, deprecated, message: "Use 'gpt-3.5-turbo-1106' instead.")
    case gpt3_5_turbo = "gpt-3.5-turbo"
    @available(*, deprecated, message: "Use 'gpt-3.5-turbo-1106' instead.")
    case gpt3_5_turbo_0613 = "gpt-3.5-turbo-0613"
    @available(*, deprecated, message: "Use 'gpt-3.5-turbo-1106' instead.")
    case gpt3_5_turbo_16k = "gpt-3.5-turbo-16k"
    @available(*, deprecated, message: "Use 'gpt-3.5-turbo-1106' instead.")
    case gpt3_5_turbo_16k_0613 = "gpt-3.5-turbo-16k-0613"
    
    @available(*, deprecated, message: "Use 'gpt-4-turbo' instead.")
    case gpt4 = "gpt-4"
    @available(*, deprecated, message: "Use 'gpt-4-turbo' instead.")
    case gpt4_0613 = "gpt-4-0613"
    @available(*, deprecated, message: "Use 'gpt-4-turbo' instead.")
    case gpt4_32k = "gpt-4-32k"
    @available(*, deprecated, message: "Use 'gpt-4-turbo' instead.")
    case gpt4_32k_0613 = "gpt-4-32k-0613"
    
    case gpt3_5_turbo_1106 = "gpt-3.5-turbo-1106"
    case gpt4_turbo = "gpt-4-turbo"
    case gpt4o = "gpt-4o"
    case gpt4o_mini = "gpt-4o-mini"
    case o1_preview = "o1-preview"
    case o1_mini = "o1-mini"
}

public extension Model {
    init(customValue: String) {
        self = Model(rawValue: customValue) ?? .custom(customValue)
    }
    
    static func custom(_ value: String) -> Model {
        return Model(rawValue: value) ?? .custom(value)
    }
}
