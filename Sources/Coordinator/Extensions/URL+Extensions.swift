//
//  URL+Extensions.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 27.04.25.
//

import Foundation

extension URL {
    
    /// Returns all remaining route components from the URL, including the host and path segments.
    /// - Returns: An array of `String` representing the host and each path component (excluding slashes).
    func remainingRoutes() -> [String] {
        var routes = [ self.host ].compactMap { $0 }
        routes.append(contentsOf: pathComponents.filter { $0 != "/" })
        return routes
    }
}
