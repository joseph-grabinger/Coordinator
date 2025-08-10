//
//  Coordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI
import OSLog

/// A protocol defining the requirements for coordinators that manage a `NavigationStack`.
///
/// This protocol enables hierarchical navigation using coordinators and routes.
///
/// - Warning: Do not set the properties manually.
public protocol StackCoordinating: Coordinating {
    
    /// The type representing a route.
    associatedtype Route: Routable

    // MARK: - Properties

    /// The initial route that this navigator starts with.
    var initialRoute: Route { get }

    /// A weak reference to the root coordinator, if available.
    /// - Important: This reference must be weak to avoid retain cycles.
    var root: (any StackNavigating)? { get set }
}

// MARK: - Navigation Methods

public extension StackCoordinating {

    /// Pushes a new coordinator onto the `NavigationStack`.
    /// - Parameter coordinator: The `StackCoordinating` instance to push.
    func push(coordinator: any StackCoordinating) {
        guard let root else {
            Logger.coordinator.warning("Cannot push \"\(coordinator.description)\" from \"\(self)\": root is nil.")
            return
        }
        root.pushCoordinator(coordinator)
    }

    /// Pushes a new route onto the `NavigationStack`.
    /// - Parameter route: The `Route` instance to push.
    func push(route: Route) {
        guard let root else {
            Logger.coordinator.warning("Cannot push \"\(route)\" from \"\(self)\": root is nil.")
            return
        }
        root.pushRoute(route)
    }

    /// Pops the top-most route from the `NavigationStack`.
    func pop() {
        guard let root else {
            Logger.coordinator.warning("Cannot pop from \"\(self)\": root is nil.")
            return
        }
        root.popRoute()
    }

    /// Pops all of the current coordinator's routes from the `NavigationStack` and returns to the initial route of the coordinator.
    func popToInitialRoute() {
        guard let root else {
            Logger.coordinator.warning("Cannot pop to initial route from \"\(self)\": root is nil.")
            return
        }
        root.popToInitialRoute(of: self)
    }

    /// Pops all routes from the `NavigationStack` and returns to the previous coordinator.
    func popToPreviousCoordinator() {
        guard let root else {
            Logger.coordinator.warning("Cannot pop to previous coordinator from \"\(self)\": root is nil.")
            return
        }
        root.popCoordinator(self)
    }

    /// Pops all routes and returns to the root of the `NavigationStack`.
    func popToRoot() {
        guard let root else {
            Logger.coordinator.warning("Cannot pop to root from \"\(self)\": root is nil.")
            return
        }
        root.popToRoot()
    }
}
