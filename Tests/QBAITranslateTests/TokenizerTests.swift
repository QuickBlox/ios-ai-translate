//
//  TokenizerTests.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import XCTest
@testable import QBAITranslate

final class TokenizerTests: XCTestCase {
    
    func testContentWith3Tokens_parseTokensCountFrom_return3() {
        let tokensCount = Tokenizer().parseTokensCount(from: "Hello my friend!")
        XCTAssertEqual(tokensCount, 3)
    }
    
    func testEmptyContent_parseTokensCountFrom_return0() {
        let tokensCount = Tokenizer().parseTokensCount(from: "")
        XCTAssertEqual(tokensCount, 0)
    }
}
