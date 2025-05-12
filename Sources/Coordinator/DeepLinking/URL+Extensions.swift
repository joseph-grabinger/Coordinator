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
    
    /// Returns all remaining route components from the URL, including the host and path segments including query arguments.
    ///
    /// This effectively drops the URL's scheme from the absolute string and splits at the remaining string at each slash.
    ///
    /// - Returns: An array of `String` representing the host and each path component.
    func remainingRoutesWithArgs() -> [String] {
        var url: String?
        if let scheme {
            url = String(absoluteString.dropFirst(scheme.count + 3))
        } else {
            url = absoluteString
        }
        
        return url?.components(separatedBy: "/") ?? []
    }
}
