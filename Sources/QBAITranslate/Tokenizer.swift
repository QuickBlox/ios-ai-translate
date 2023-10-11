//
//  Tokenizer.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

/// Represents the protocol for tokenizing messages and extracting a subset of messages based on token count.
public protocol TokenizerProtocol {
    /**
     Parses the token count from the provided content using CFStringTokenizer.
     
     - Parameters:
        - content: The content string to be tokenized.
     
     - Returns: The token count in the content string.
     */
    func parseTokensCount(from content: String) -> Int
    
    /**
     Extracts a subset of messages based on the provided maximum token count.
     
     - Parameters:
        - messages: An array of Message objects representing the chat history.
        - maxCount: The maximum token count allowed for message processing.
     
     - Returns: A filtered array of Message objects containing a subset of messages.
     */
    func extract<M>(messages: [M]?,
                    byTokenLimit maxCount: Int) -> [M] where M: Message
}

/// Represents the default implementation of TokenizerProtocol using CFStringTokenizer to tokenize messages.
open class Tokenizer: TokenizerProtocol {
    /**
     Extracts a subset of messages based on the provided maximum token count.
     
     - Parameters:
        - messages: An array of Message objects representing the chat history.
        - maxCount: The maximum token count allowed for message processing.
     
     - Returns: A filtered array of Message objects containing a subset of messages.
     */
    public func extract<M>(messages: [M]?,
                           byTokenLimit maxCount: Int) -> [M] where M: Message {
        guard let messages = messages else { return [] }
        if messages.isEmpty { return [] }
        
        var tokensCount = 0
        var extractedMessages: [M] = []
        
        for message in messages.reversed() {
            let messageContent = message.text
            tokensCount += parseTokensCount(from: messageContent)
            if tokensCount >= maxCount {
                break
            }
            extractedMessages.append(message)
        }
        
        return extractedMessages.reversed()
    }
    
    /**
     Parses the token count from the provided content using CFStringTokenizer.
     
     - Parameters:
        - content: The content string to be tokenized.
     
     - Returns: The token count in the content string.
     */
    public func parseTokensCount(from content: String) -> Int {
        var tokensCount = 0
        
        let tokenizer = CFStringTokenizerCreate(
            kCFAllocatorDefault,
            content as CFString,
            CFRangeMake(0, content.count),
            kCFStringTokenizerAttributeLanguage,
            CFLocaleCopyCurrent()
        )
        
        while CFStringTokenizerAdvanceToNextToken(tokenizer) != CFStringTokenizerTokenType(rawValue: 0) {
            tokensCount += 1
        }
        
        return tokensCount
    }
}
