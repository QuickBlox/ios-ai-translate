//
//  QBAITranslateTests.swift
//
//  Created by Injoit on 21.08.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import XCTest
@testable import QBAITranslate

final class QBAITranslateIntegrationTests: XCTestCase {
    func testHasText_translateByOpenAIWithTokenToSystemLanguage_returnAnswer() async {
        do {
            let settings = AISettings(apiKey: Config.openAIToken,
                                      language: .ukrainian)
            let clinicAnswers = try await QBAITranslate.translate(text: Test.clinicText,
                                                                  history: Test.clinicMessages,
                                                                  using: settings)
            print(clinicAnswers)
            XCTAssertFalse(clinicAnswers.isEmpty)
            
            let supportAnswers = try await QBAITranslate.translate(text: Test.supportText,
                                                                   history: Test.clinicMessages,
                                                                   using: settings)
            print(supportAnswers)
            XCTAssertFalse(supportAnswers.isEmpty)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testHasWrongText_translateByOpenAIWithTokenToSystemLanguage_returnExeption() async {
        do {
            let settings = AISettings(apiKey: Config.openAIToken,
                                      language: .ukrainian)
            let answers = try await QBAITranslate.translate(text: Test.wrongText,
                                                                  history: Test.wrongMessages,
                                                                  using: settings)
            print(answers)
            XCTFail("Expected error")
        } catch {
            print(error)
            XCTAssertNotNil(error)
        }
    }
    
    // To start this tests we need to have running Proxy server
    // The repository is: https://github.com/QuickBlox/qb-ai-assistant-proxy-server
    func testHasText_translateByProxy_returnAnswer() async {
        do {
            let settings = AISettings(token: Config.qbToken,
                                      serverPath: "http://localhost:3000",
                                      language: .ukrainian)
            
            let clinicAnswers = try await QBAITranslate.translate(text: Test.clinicText,
                                                            using: settings)
            print(clinicAnswers)
            XCTAssertFalse(clinicAnswers.isEmpty)
            
            let supportAnswers = try await QBAITranslate.translate(text: Test.supportText,
                                                            using: settings)
            print(supportAnswers)
            XCTAssertFalse(supportAnswers.isEmpty)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
