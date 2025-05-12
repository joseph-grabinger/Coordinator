//
//  Coordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI
import OSLog

/// A protocol defining the requirements for coordinators that navigate using a `NavigationStack`.
///
/// This protocol enables hierarchical navigation using coordinators and routes.
///
/// - Warning: Do not set the properties manually.
@MainActor
public protocol StackCoordinating: Coordinating {
    /// The type representing a navigation route.
    associatedtype Route: Routable

    // MARK: - Properties

    /// The initial route this coordinator starts with.
    var initialRoute: Route { get }

    /// A weak reference to the root navigation path manager, used to coordinate navigation.
    /// - Important: This reference must be weak to avoid retain cycles.
    var root: (any SharedPathManaging)? { get set }

    /// The routes currently presented on the navigation stack.
    /// - Warning: Do not mutate this directly. Use navigation methods instead.
    var presentedRoutes: [Route] { get set }
}

// MARK: - Default Implementations

public extension StackCoordinating {

    /// Pushes another coordinator onto the navigation stack.
    /// - Parameter coordinator: The `StackCoordinating` instance to push.
    func pushCoordinator(_ coordinator: some StackCoordinating) {
        guard let root else {
            Logger.navKit.warning("Cannot push \"\(coordinator)\": root is nil")
            return
        }
        coordinator.root = root
        root.pushCoordinator(coordinator)
    }

    /// Pushes a new route onto the navigation stack.
    /// - Parameter route: The `Route` instance to present.
    func pushRoute(_ route: Route) {
        guard let root else {
            Logger.navKit.warning("Cannot push \"\(route)\": root is nil")
            return
        }
        root.pushRoute(route)
        presentedRoutes.append(route)
    }

    /// Pops the top-most route from the navigation stack.
    func pop() {
        guard let root else {
            Logger.navKit.warning("Cannot pop: root is nil")
            return
        }
        root.pop()
        guard presentedRoutes.count >= 1 else { return }
        presentedRoutes.removeLast()
    }

    /// Pops all routes and returns to the initial route of the coordinator.
    func popToInitialRoute() {
        guard let root else {
            Logger.navKit.warning("Cannot pop to initial route: root is nil")
            return
        }
        root.popLast(presentedRoutes.count)
        presentedRoutes = []
    }

    /// Pops all routes and returns to the previous coordinator.
    func popToPreviousCoordinator() {
        guard let root else {
            Logger.navKit.warning("Cannot pop to previous coordinator: root is nil")
            return
        }
        guard root.path.count > presentedRoutes.count else {
            Logger.navKit.warning("Cannot pop to previous coordinator: routes inconsistent with root path")
            return
        }
        root.popLast(presentedRoutes.count + 1)
        presentedRoutes = []
    }

    /// Pops all routes and returns to the root of the stack.
    func popToRoot() {
        root?.popToRoot()
    }

    /// Removes the last `k` routes from the presented routes array.
    /// - Parameter k: The number of routes to remove.
    private func popLast(_ k: Int = 1) {
        presentedRoutes.removeLast(k)
    }
}
