//
//  QBAITranslate.swift
//
//  Created by Injoit on 15.08.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

public var dependency: DependencyProtocol = Dependency()

/// Translates a text.
///
/// Using `Settings.serverPath` a proxy server  like the [QuickBlox AI Assistant Proxy Server](https:github.com/QuickBlox/qb-ai-assistant-proxy-server) offers significant benefits in terms of security and functionality:
///
/// - Parameters:
///  - text: The text to be translated.
///  - messages: An array of `Message` objects representing the chat history.
///  - settings: The settings conforming to the `Settings` protocol, including language, API key, user token, and server path.
///
/// - Returns: The translated text as a String.
///
public func translate<M, S>(text: String,
                            history messages: [M],
                            using settings: S) async throws -> String
where M: Message, S: Settings {
    let textTokens = dependency.tokenizer.parseTokensCount(from: text)
    if textTokens > settings.maxRequestTokens {
        throw QBAIException.incorrectTokensCount
    }
    
    let tokens = settings.maxRequestTokens - textTokens
    let filteredMessages = dependency.tokenizer.extract(messages: messages,
                                                        byTokenLimit: tokens)
    
    
    return try await dependency.restSource.request(translate: text,
                                                   with: filteredMessages,
                                                   using: settings)
}

/// Translates a text.
///
/// Using `Settings.serverPath` a proxy server  like the [QuickBlox AI Assistant Proxy Server](https:github.com/QuickBlox/qb-ai-assistant-proxy-server) offers significant benefits in terms of security and functionality:
///
/// - Parameters:
///  - text: The text to be translated.
///  - settings: The settings conforming to the `Settings` protocol, including language, API key, user token, and server path.
///
/// - Returns: The translated text as a String.
///
public func translate<S>(text: String, using settings: S)
async throws -> String where S: Settings {
    let empty: [AIMessage] = []
    return try await translate(text: text, history: empty, using: settings)
}
