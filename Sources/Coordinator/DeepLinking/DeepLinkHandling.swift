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
