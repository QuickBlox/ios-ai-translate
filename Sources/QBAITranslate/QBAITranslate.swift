//
//  QBAITranslate.swift
//
//  Created by Injoit on 15.08.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

public enum Language: String {
    case english = "en"
    case spanish = "es"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case french = "fr"
    case german = "de"
    case japanese = "ja"
    case korean = "ko"
    case italian = "it"
    case russian = "ru"
    case portuguese = "pt"
    case arabic = "ar"
    case hindi = "hi"
    case turkish = "tr"
    case dutch = "nl"
    case polish = "pl"
    case ukrainian = "uk"
    case albanian = "sq"
    case armenian = "hy"
    case azerbaijani = "az"
    case basque = "eu"
    case belarusian = "be"
    case bengali = "bn"
    case bosnian = "bs"
    case bulgarian = "bg"
    case catalan = "ca"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case estonian = "et"
    case finnish = "fi"
    case galician = "gl"
    case georgian = "ka"
    case greek = "el"
    case gujarati = "gu"
    case hungarian = "hu"
    case indonesian = "id"
    case irish = "ga"
    case kannada = "kn"
    case kazakh = "kk"
    case latvian = "lv"
    case lithuanian = "lt"
    case macedonian = "mk"
    case malay = "ms"
    case maltese = "mt"
    case mongolian = "mn"
    case nepali = "ne"
    case norwegian = "no"
    case pashto = "ps"
    case persian = "fa"
    case punjabi = "pa"
    case romanian = "ro"
    case sanskrit = "sa"
    case serbian = "sr"
    case sindhi = "sd"
    case sinhala = "si"
    case slovak = "sk"
    case slovenian = "sl"
    case urdu = "ur"
    case uzbek = "uz"
    case vietnamese = "vi"
    case welsh = "cy"
    
    /// Returns the `Locale` associated with the language.
    public var locale: Locale {
        return Locale(identifier: rawValue)
    }
}

/// A protocol defining methods to manage language settings.
public protocol LanguageSettings {
    /// The current language as a localized string.
    var language: String { get }
    
    /// Sets a custom language using a `Language` enum case.
    /// - Parameter language: The language to set.
    func setCustom(language: Language)
    
    /// Sets a custom language using a `Locale` object.
    ///
    /// Use this method to set a custom language using a `Locale` object. To see available
    /// `Locale` identifiers, you can use the following code:
    ///
    /// ```
    /// print(Locale.availableIdentifiers)
    /// ```
    ///
    /// - Parameter locale: The locale to set. Provide a `Locale` object corresponding to
    ///                     the desired language and region.
    func setCustomLanguage(from locale: Locale)
    
    /// Resets the custom language and falls back to the English.
    func resetLanguage()
}

/// Represents the settings used for QBAITranslate.
public var settings = QBAITranslate.Settings()

public class Settings: LanguageSettings {
    /// The maximum token count allowed for message processing.
    public var maxTokenCount: Int = 3500
    
    /// Settings for OpenAI model usage.
    public var openAI: OpenAISettings = OpenAISettings()
    
    /// The current language as a localized string. English language by default.
    public var language: String {
        return locale?.languageName ?? "English"
    }
    
    /// The current locale, either custom.
    private var locale: Locale? {
        get {
            return QBAITranslate.Cache.locale
        } set {
            QBAITranslate.Cache.locale = newValue
        }
    }
    
    /// Sets a custom language using a `Language` enum case.
    /// - Parameter language: The language to set.
    public func setCustom(language: Language) {
        locale = language.locale
    }
    
    /// Sets a custom language using a `Locale` object.
    ///
    /// Use this method to set a custom language using a `Locale` object.
    /// ```
    /// settings.setCustomLanguage(from: Locale(identifier: "es-US"))
    /// ```
    ///
    /// To see available `Locale` identifiers, you can use the following code:
    /// ```
    /// print(Locale.availableIdentifiers)
    /// ```
    ///
    /// - Parameter locale: The locale to set. Provide a `Locale` object corresponding to
    ///                     the desired language and region.
    public func setCustomLanguage(from locale: Locale) {
        self.locale = locale
    }
    
    /// Resets the custom language and falls back to the English.
    public func resetLanguage() {
        locale = nil
    }
}

private extension Locale {
    /// Returns the localized language name for the locale.
    var languageName: String? {
        guard let code = self.languageCode else {
            return nil
        }
        
        let english = QBAITranslate.Language.english
        return english.locale.localizedString(forLanguageCode: code)
    }
}

private final class Cache {
    /// The UserDefaults key used for storing custom locale data.
    static var key = "QBAITranslate.CustomLocale"
    
    /// The custom locale stored in UserDefaults.
    static var locale: Locale? {
        get {
            if let data = UserDefaults.standard.data(forKey: Cache.key) {
                let decoder = JSONDecoder()
                if let locale = try? decoder.decode(Locale.self, from: data) {
                    return locale
                }
            }
            return nil
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: Cache.key)
            } else if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: Cache.key)
            }
        }
    }
}

/// Represents the various exceptions that can be thrown by `QBAIAnswerAssistant`.
public enum QBAIException: Error {
    /// Thrown when the provided token has an incorrect value.
    case incorrectToken
    
    /// Thrown when the provided text tokens count has an incorrect value.
    case incorrectTokensCount
    
    /// Thrown when the server URL has an incorrect value.
    case incorrectProxyServerUrl
}

public var dependency: DependencyProtocol = Dependency()

/// Generates a translation using the OpenAI API by making direct requests with the provided API key.
///
/// This method translates the provided text using the OpenAI API with the given API key. It sends a request to OpenAI for translation and returns the generated translation as a String.
///
/// - Parameters:
///   - text: The text to be translated.
///   - apiKey: The API key to be used for making the request to OpenAI.
///
/// - Throws: A `QBAIException` if an error occurs during the request or validation.
///
/// - Returns: The generated translation as a String.
public func openAI(translate text: String,
                   secret apiKey: String) async throws -> String {
    if apiKey.isNotCorrect {
        throw QBAIException.incorrectToken
    }
    
    let tokenizer = Tokenizer()
    let count = tokenizer.parseTokensCount(from: text)
    
    if count > QBAITranslate.settings.maxTokenCount {
        throw QBAIException.incorrectTokensCount
    }
    
    let rest = QBAITranslate.dependency.restSource
    let answer =
    try await rest.requestOpenAI(translate: text,
                                 language: QBAITranslate.settings.language,
                                 key: apiKey,
                                 apply: QBAITranslate.settings.openAI)
    
    return answer
}

/// Generates a translation using the OpenAI API through a QuickBlox user token and proxy URL.
///
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
///   - text: The text to be translated.
///   - qbToken: The QuickBlox user token used for proxy communication.
///   - urlPath: The proxy URL to be used for making the request to OpenAI.
///
/// - Throws: A `QBAIException` if an error occurs during the request or validation.
///
/// - Returns: The generated answer as a String.
///
public func openAI(translate text: String,
                   qbToken: String,
                   proxy urlPath: String) async throws -> String {
    if qbToken.isNotCorrect {
        throw QBAIException.incorrectToken
    }
    
    if ServerUrlValidator.isNotCorrect(urlPath) {
        throw QBAIException.incorrectProxyServerUrl
    }
    
    let tokenizer = Tokenizer()
    let count = tokenizer.parseTokensCount(from: text)
    if count > QBAITranslate.settings.maxTokenCount {
        throw QBAIException.incorrectTokensCount
    }
    
    let rest = QBAITranslate.dependency.restSource
    let answer =
    try await rest.requestOpenAI(translate: text,
                                 language: QBAITranslate.settings.language,
                                 token: qbToken,
                                 proxy: urlPath,
                                 apply: QBAITranslate.settings.openAI)
    return answer
}

/// Extension to provide a utility method to check if a string is not correct by removing whitespaces and newlines from both ends and checking if the resulting string is empty.
extension String {
    var isNotCorrect: Bool {
        // Remove whitespaces and newlines from both ends of the string
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        // Check if the resulting string is empty
        return trimmedString.isEmpty
    }
}
