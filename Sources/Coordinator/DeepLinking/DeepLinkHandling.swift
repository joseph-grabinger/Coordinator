//
//  DeepLinkHandling.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 27.04.25.
//

import Foundation

/// A protocol that defines the requirements for handling deep links.
public protocol DeepLinkHandling {

    /// Handles the given deep link.
    /// - Parameter deepLink: The deep link to process.
    func handleDeepLink(_ deepLink: DeepLink) throws
}

// - MARK: DeepLinkValidityChecking

/// A protocol that defines the requirements for checking the validity of deep links.
public protocol DeepLinkValidityChecking {
    
    /// Checks whether a given `DeepLink` can be handled.
    /// - Parameter deepLink: The deep link to check.
    /// - Returns: `true` if the deep link can be handled, else `false` is returned.
    static func canHandleDeepLink(_ deepLink: DeepLink) -> Bool
}
