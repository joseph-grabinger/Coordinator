//
//  StackNavigating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 10.08.25.
//

import Foundation

/// A protocol that defines methods for stack-based navigation.
@MainActor
public protocol StackNavigating: ObservableObject, CustomStringConvertible {
    
    // MARK: Methods
    
    /// Pushes a new coordinator onto the navigation stack.
    /// - Parameter coordinator: A `StackCoordinating`-conforming instance to push.
    func pushCoordinator(_ coordinator: any StackCoordinating)
    
    /// Pushes a new `Route` onto the navigation stack.
    /// - Parameter route: A `Routable`-conforming route to push.
    func pushRoute<Route: Routable>(_ route: Route)
    
    /// Pops the specified number of routes of the navigation stack.
    /// - Parameter count: The number of routes to pop.
    func popRoute(count: Int)
    
    /// Pops all routes of the navigation stack.
    ///
    /// This effectively resets the stack to its initial route.
    func popToRoot()
}

// MARK: - Convenience Methods

public extension StackNavigating {
    
    /// Pops the top-most route of the navigation stack.
    func popRoute() {
        self.popRoute(count: 1)
    }
}

// MARK: CustomStringConvertible

public extension StackNavigating {

    nonisolated var description: String {
        let typeName = String(describing: Self.self)
        let objectID = ObjectIdentifier(self)
        return "\(typeName)(objectID: \"\(objectID)\")"
    }
}
