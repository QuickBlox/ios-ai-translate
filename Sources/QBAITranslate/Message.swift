//
//  Message.swift
//
//  Created by Injoit on 22.09.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

public protocol Message {
    var role: Role { get }
    var text: String { get }
    
    init(role: Role, text: String)
}

public enum Role {
    case me
    case other
}

public struct AIMessage: Message {
    public var role: Role
    public var text: String
    
    public init(role: Role, text: String) {
        self.role = role
        self.text = text
    }
}
