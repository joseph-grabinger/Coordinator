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
    
    /// The remainaing routes a deep link, which still have to be handeled.
    public var remainingRoutes: [String]
    
    // - MARK: Initialization
    
    /// Initializes a `DeepLink` from a given `URL`.
    /// - Parameter url: The `URL` from which the `DeepLink` should be created.
    public init(from url: URL) {
        self.url = url
        self.remainingRoutes = url.remainingRoutes()
    }
}
