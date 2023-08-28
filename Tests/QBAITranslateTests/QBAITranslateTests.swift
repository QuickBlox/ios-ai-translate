//
//  QBAITranslateTests.swift
//
//  Created by Injoit on 15.08.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//


import XCTest
@testable import QBAITranslate

final class QBAITranslateTests: XCTestCase {
    func testLanguageSettings() throws {
        print(Locale.availableIdentifiers)
        
        XCTAssertEqual(QBAITranslate.settings.language, "English")
        
        QBAITranslate.settings.setCustomLanguage(from: Language.spanish.locale)
        XCTAssertEqual(QBAITranslate.settings.language, "Spanish")
        
        QBAITranslate.settings.setCustom(language: .ukrainian)
        XCTAssertEqual(QBAITranslate.settings.language, "Ukrainian")
        
        QBAITranslate.settings.resetLanguage()
    }

}
