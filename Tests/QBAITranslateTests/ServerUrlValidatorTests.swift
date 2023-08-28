//
//  ServerUrlValidatorTests.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import XCTest
@testable import QBAITranslate

class ServerUrlValidatorTests: XCTestCase {

    func testServerUrlWithHttps_isHttps_true() {
        let isHttps = ServerUrlValidator.isHttps("https://")
        XCTAssertTrue(isHttps)
    }

    func testServerUrlWithoutHttps_isHttps_false() {
        let isHttps = ServerUrlValidator.isHttps("custom.com")
        XCTAssertFalse(isHttps)
    }

    func testServerUrlWithHttp_isHttps_true() {
        let isHttp = ServerUrlValidator.isHttp("http://")
        XCTAssertTrue(isHttp)
    }

    func testServerUrlWithoutHttp_isHttps_false() {
        let isHttp = ServerUrlValidator.isHttp("custom.com")
        XCTAssertFalse(isHttp)
    }

    func testCorrectServerUrl_isNotCorrect_false() {
        let isNotCorrect = ServerUrlValidator.isNotCorrect("https://custom.com")
        XCTAssertFalse(isNotCorrect)
    }

    func testEmptyServerUrl_isNotCorrect_true() {
        let isNotCorrect = ServerUrlValidator.isNotCorrect("")
        XCTAssertTrue(isNotCorrect)
    }

    func testServerUrlWithoutHttps_isServerUrlNotCorrect_noErrors() {
        let isNotCorrect = ServerUrlValidator.isNotCorrect("www.custom.com")
        XCTAssertTrue(isNotCorrect)
    }
}

