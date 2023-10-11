//
//  TestUtil.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation
@testable import QBAITranslate

struct Test {
    static let clinicText = "Estoy visitando desde España y he perdido mis medicamentos recetados. ¿Puede ayudarme a conseguir más antibióticos?"
    static let clinicMessages = [
        AIMessage(role: .me, text: "Hello! I’m Dr Sheridan. How can I help?"),
        AIMessage(role: .other, text: Test.clinicText)
    ]
    
    static let supportText = "No problem. I can assist you in Ukrainian. Please begin by completing the online order form. You can complete the form in your native language."
    
    static let supportMessages = [
        AIMessage(role: .other, text: "I would like to go ahead with the purchase, but my English is bad."),
        AIMessage(role: .me, text: Test.supportText)
    ]
    
    static let wrongText = "12441325 t334r454  45t 3f g 4h2d2d23"
    static let wrongMessages = [
        AIMessage(role: .me, text: "Hello! I’m Dr Sheridan. How can I help?"),
        AIMessage(role: .other, text: Test.wrongText)
    ]
}
