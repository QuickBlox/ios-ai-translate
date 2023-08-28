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
}

/// Represents the default implementation of TokenizerProtocol using CFStringTokenizer to tokenize messages.
open class Tokenizer: TokenizerProtocol {
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
