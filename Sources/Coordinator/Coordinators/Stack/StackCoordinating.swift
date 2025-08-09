//
//  Coordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

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
    var root: (any RootStackCoordinating)? { get set }

    /// The navigation path representing the current state of navigation.
    var presentedRoutes: [Route] { get set }
}

// MARK: - Default Implementations

public extension StackCoordinating {

    /// Default implementation of `pushCoordinator(_:)`, adding a coordinator to the `NavigationPath`.
    /// - Parameter coordinator: The `Coordinator` to push.
    func push(coordinator: any StackCoordinating) {
        guard let root else {
            print("Root is nil, cannot push coordinator")
            return
        }
        coordinator.root = root
        root.push(coordinator: coordinator)
    }

    /// Default implementation of `push(_:)`, adding a route to the navigation path.
    /// - Parameter route: The `Routable` instance to be pushed onto the stack.
    func push(route: Route) {
        guard let root else {
            print("Root is nil, cannot push route")
            return
        }
        root.push(route)
        presentedRoutes.append(route)
    }

    /// Default implementation of `pop()`, removing the last item from the `NavigationPath`.
    func pop() {
        guard let root else {
            print("Root is nil, cannot pop route")
            return
        }
        root.pop()
        guard presentedRoutes.count >= 1 else { return }
        presentedRoutes.removeLast()
    }

    /// Default implementation of `popToRoot()`, removing all items from the `NavigationPath`.
    func popToRoot() {
        guard let root else {
            print("Root is nil, cannot pop to root")
            return
        }
        root.popLast(presentedRoutes.count)
        presentedRoutes = []
    }

    func popToPrevious() {
        guard let root,
              root.path.count > presentedRoutes.count
        else {
            print("Root is nil, cannot pop to root")
            return
        }
        root.popLast(presentedRoutes.count + 1)
        presentedRoutes = []
    }

    /// Pops the navigation stack all the way to the root of the root coordinator.
    ///
    /// In a coordinator hierarchy, the "root of root" refers to the top-most coordinator that manages
    /// the entire navigation stack. This method delegates to the root coordinator's `popToRoot()` method,
    /// ensuring that navigation returns to the very beginning of the stack, regardless of the current depth.
    func popToRootRoot() {
        root?.popToRoot()
    }
}

// MARK: - Private Helper

private extension StackCoordinating {

    /// Pops the last `k` items from the navigation path.
    /// - Parameter k: The number of items to remove (default is 1).
    func popLast(_ k: Int = 1) {
        presentedRoutes.removeLast(k)
    }
}
