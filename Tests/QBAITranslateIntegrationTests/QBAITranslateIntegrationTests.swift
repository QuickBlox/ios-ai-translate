//
//  QBAITranslateTests.swift
//
//  Created by Injoit on 21.08.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import XCTest
@testable import QBAITranslate

final class QBAITranslateIntegrationTests: XCTestCase {
    override func tearDown() async throws {
        QBAITranslate.settings.resetLanguage()
        
        try await super.tearDown()
    }
    
    func testHasText_translateByOpenAIWithTokenToSystemLanguage_returnAnswer() async {
        do {
            let answers = try await
            QBAITranslate.openAI(translate: Test.text,
                                 secret: Config.openAIToken)
            
            print(answers)
            XCTAssertFalse(answers.isEmpty)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testHasText_translateByOpenAIWithTokenToCustomLanguge_returnAnswer() async {
        do {
            QBAITranslate.settings.setCustom(language: .spanish)
            let customLanguageAnswer = try await
            QBAITranslate.openAI(translate: Test.text,
                                 secret: Config.openAIToken)
            
            print(customLanguageAnswer)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // To start this tests we need to have running Proxy server
    // The repository is: https://github.com/QuickBlox/qb-ai-assistant-proxy-server
    func testHasText_translateByProxy_returnAnswer() async {
        do {
            let answers = try await
            QBAITranslate.openAI(translate: Test.text,
                                 qbToken: Config.qbToken,
                                 proxy: "http://localhost:3000")
            print(answers)
            XCTAssertFalse(answers.isEmpty)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
}
