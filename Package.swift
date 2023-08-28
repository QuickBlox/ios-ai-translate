// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  QBAITranslate.swift
//
//  Created by Injoit on 15.08.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "QBAITranslate",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "QBAITranslate",
            targets: ["QBAITranslate"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "QBAITranslate"),
        .testTarget(
            name: "QBAITranslateTests",
            dependencies: ["QBAITranslate"]),
        .testTarget(
            name: "QBAITranslateIntegrationTests",
            dependencies: ["QBAITranslate"]),
    ]
)
