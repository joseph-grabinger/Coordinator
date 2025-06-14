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
@MainActor
public protocol StackCoordinating: ObservableObject, Identifiable, Hashable {
    /// The type representing a route.
    associatedtype Route: Routable
    
    // MARK: - Properties
    
    /// The initial route that this navigator starts with.
    var initialRoute: Route { get }
    
    /// A weak reference to the root coordinator, if available.
	var root: (any RootStackCoordinating)? { get set }

    /// The navigation path representing the current state of navigation.
    var path: NavigationPath { get set }
    
    // MARK: - Methods

    /// Pushes a new `Coordinator` onto the `NavigationStack`.
    /// - Parameter coordinator: The `Coordinator` instance to be added.
    func pushCoordinator(_ coordinator: any StackCoordinating)
    
    /// Pushes a new `Route` onto the `NavigationStack`.
    ///
    /// > The `Route` type is bound to the coordinator's associated type. Thus, only the coordinator's routes can be pushed.
    ///
    /// - Parameter route: The `Route` to push.
    func push(_ route: Route)

    /// Pops the top-most view from the navigation stack.
    func pop()

    /// Pops all views of the current `Coordinator`.
    /// - This effectively displays the current coordinator's `initialRoute`.
    func popToRoot()
}

// MARK: - Hashable Conformance

public extension StackCoordinating {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Default Implementations

public extension StackCoordinating {
    
    /// Default implementation of `pushCoordinator(_:)`, adding a coordinator to the `NavigationPath`.
    /// - Parameter coordinator: The `Coordinator` to push.
    func pushCoordinator(_ coordinator: any StackCoordinating) {
		guard let root else {
			print("Root is nil, cannot push coordinator")
			return
		}
		coordinator.root = root
		root.pushCoordinator(coordinator)
    }
    
    /// Default implementation of `push(_:)`, adding a route to the navigation path.
    /// - Parameter route: The `Routable` instance to be pushed onto the stack.
    func push(_ route: Route) {
		guard let root else {
			print("Root is nil, cannot push route")
			return
		}
        root.push(route)
		path.append(route)
    }
    
    /// Default implementation of `pop()`, removing the last item from the `NavigationPath`.
    func pop() {
		guard let root else {
			print("Root is nil, cannot pop route")
			return
		}
        root.pop()
        guard path.count >= 1 else { return }
		path.removeLast()
    }
    
    /// Default implementation of `popToRoot()`, removing all items from the `NavigationPath`.
    func popToRoot() {
		guard let root else {
			print("Root is nil, cannot pop to root")
			return
		}
		root.popLast(path.count)
        path = NavigationPath()
    }
}

// MARK: - Private Helper

private extension StackCoordinating {
    
    /// Pops the last `k` items from the navigation path.
    /// - Parameter k: The number of items to remove (default is 1).
    func popLast(_ k: Int = 1) {
        path.removeLast(k)
    }
}
