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
    /// - Parameter coordinator: The `StackCoordinating`-conforming instance to push.
    func pushCoordinator(_ coordinator: any StackCoordinating)
    
    /// Pushes a new `Route` onto the navigation stack.
    /// - Parameter route: The `Routable`-conforming route to push.
    func pushRoute<Route: Routable>(_ route: Route)
    
    /// Pops the specified number of routes of the navigation stack.
    /// - Parameter count: The number of routes to pop.
    func popRoute(count: Int)
    
    /// Pops the current coordinator of the navigation stack.
    /// 
    /// This effectively displays the lat route before the given coordinator.
    ///
    /// - Parameter coordinator: The `StackCoordinating`-conforming instance to pop.
    func popCoordinator(_ coordinator: any StackCoordinating)
    
    /// Pops all routes until the initial route of the given coordinator of the navigation stack.
    /// - Parameter coordinator: The `StackCoordinating`-conforming instance to whose initial route to pop.
    func popToInitialRoute(of coordinator: any StackCoordinating)
    
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
