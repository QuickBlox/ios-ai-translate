//
//  Dependency.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

/// Represents the dependency protocol that can be used to inject custom implementations of `TokenizerProtocol` and `RestSourceProtocol`.
public protocol DependencyProtocol {
    var tokenizer: TokenizerProtocol { get set }
    var restSource: RestSourceProtocol { get set }
}

/// Represents the default implementation of `DependencyProtocol` using `Tokenizer` and `RestSource`.
public struct Dependency: DependencyProtocol {
    public var tokenizer: TokenizerProtocol = Tokenizer()
    public var restSource: RestSourceProtocol = RestSource()
}
