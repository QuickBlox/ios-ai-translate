//
//  ServerUrlValidator.swift
//  QBAITranslate
//
//  Created by Injoit on 19.05.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

/// Represents a utility class for validating server URLs.
class ServerUrlValidator {
    /**
     Checks if the provided URL is not correct.
     
     - Parameters:
        - url: The URL string to be validated.
     
     - Returns: A boolean indicating whether the URL is not correct.
     */
    static func isNotCorrect(_ url: String) -> Bool {
        if url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }

        let isNotHttpAndHttps = !Self.isHttp(url) && !Self.isHttps(url)
        if isNotHttpAndHttps {
            return true
        }
        return false
    }

    /**
     Checks if the provided URL uses HTTP.
     
     - Parameters:
        - url: The URL string to be checked.
     
     - Returns: A boolean indicating whether the URL uses HTTP.
     */
    static func isHttp(_ url: String) -> Bool {
        return url.count > 6 && url.lowercased().hasPrefix("http://")
    }

    /**
     Checks if the provided URL uses HTTPS.
     
     - Parameters:
        - url: The URL string to be checked.
     
     - Returns: A boolean indicating whether the URL uses HTTPS.
     */
    static func isHttps(_ url: String) -> Bool {
        return url.count > 7 && url.lowercased().hasPrefix("https://")
    }
}

