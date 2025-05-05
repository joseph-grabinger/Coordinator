//
//  DeepLink.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 27.04.25.
//

import Foundation

/// A model representing a deep link target.
public class DeepLink {
    
    /// The URL of the deep link.
    public let url: URL
    
    /// The remaining routes of a deep link `URL`, which still have to be handled.
    public var remainingRoutes: [String]
    
    // - MARK: Initialization
    
    /// Initializes a `DeepLink`.
    /// - Parameters:
    ///   - url: The URL of the deep link.
    ///   - remainingRoutes: The remaining routes of the deep link.
    public init(url: URL, remainingRoutes: [String]) {
        self.url = url
        self.remainingRoutes = remainingRoutes
    }
    
    /// Initializes a `DeepLink` from a given `URL`.
    /// - Parameter url: The `URL` from which the `DeepLink` should be created.
    public convenience init(from url: URL) {
        self.init(url: url, remainingRoutes: url.remainingRoutes())
    }
}
