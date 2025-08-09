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
@MainActor
public protocol StackCoordinating: Coordinating {
    
    /// The type representing a route.
    associatedtype Route: Routable

    // MARK: - Properties

    /// The initial route that this navigator starts with.
    var initialRoute: Route { get }

    /// A weak reference to the root coordinator, if available.
    /// - Important: This reference must be weak to avoid retain cycles.
    var root: (any RootStackCoordinating)? { get set }

    /// The navigation path representing the current state of navigation.
    /// - Warning: Do not mutate this directly. Use navigation methods instead.
    var presentedRoutes: [Route] { get set }
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
        coordinator.root = root
        root.push(coordinator: coordinator)
    }

    /// Pushes a new route onto the `NavigationStack`.
    /// - Parameter route: The `Route` instance to push.
    func push(route: Route) {
        guard let root else {
            Logger.coordinator.warning("Cannot push \"\(route)\" from \"\(self)\": root is nil.")
            return
        }
        root.push(route)
        presentedRoutes.append(route)
    }

    /// Pops the top-most route from the `NavigationStack`.
    func pop() {
        guard let root else {
            Logger.coordinator.warning("Cannot pop from \"\(self)\": root is nil.")
            return
        }
        root.pop()
        guard presentedRoutes.count >= 1 else { return }
        presentedRoutes.removeLast()
    }

    /// Pops all of the current coordinator's routes from the `NavigationStack` and returns to the initial route of the coordinator.
    func popToInitialRoute() {
        guard let root else {
            Logger.coordinator.warning("Cannot pop to initial route from \"\(self)\": root is nil.")
            return
        }
        root.popLast(presentedRoutes.count)
        presentedRoutes = []
    }

    /// Pops all routes from the `NavigationStack` and returns to the previous coordinator.
    func popToPrevious() {
        guard let root else {
            Logger.coordinator.warning("Cannot pop to previous coordinator from \"\(self)\": root is nil.")
            return
        }
        guard root.path.count > presentedRoutes.count else {
            Logger.coordinator.warning("Cannot pop to previous coordinator from \"\(self)\": routes inconsistent with root path.")
            return
        }
        root.popLast(presentedRoutes.count + 1)
        presentedRoutes = []
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
