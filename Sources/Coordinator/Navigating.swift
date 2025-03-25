//
//  Navigating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A protocol defining navigation behaviors for managing a SwiftUI `NavigationStack`.
/// - This protocol enables hierarchical navigation using coordinators and routes.
@MainActor
public protocol Navigating: ObservableObject {
    associatedtype Route: Routable
    
    // MARK: - Properties
    
    /// The initial route that this navigator starts with.
    var initialRoute: Route { get }
    
    /// A weak reference to the root navigator, if available.
	var root: (any Navigating)? { get }

    /// The navigation path representing the current state of navigation.
    var path: NavigationPath { get set }
    
    // MARK: - Methods

    /// Pushes a new `Coordinator` onto the navigation stack.
    /// - Parameter coordinator: The `Coordinator` instance to be added.
    func pushCoordinator<R: Routable>(_ coordinator: Coordinator<R>)
    
    /// Pushes a new route onto the navigation stack.
    /// - Parameter route: The `Routable` instance representing the destination.
    func push<Route: Routable>(_ route: Route)

    /// Pops the top-most view from the navigation stack.
    func pop()

    /// Pops all views of the current coordinator except the root view.
    /// - This effectively only leaves the root of the current coordinator's navigation path.
    func popToRoot()
}

// MARK: - Default Implementations

public extension Navigating {
    
    /// Pushes a new `Coordinator` onto the navigation stack.
    /// - Ensures the coordinator has its initial route set and assigns it a parent if needed.
    /// - Calls `pushCoordinator(_:)` on the parent to maintain hierarchy.
    /// - Parameter coordinator: The `Coordinator` to push.
    func pushCoordinator<Route: Routable>(_ coordinator: Coordinator<Route>) {
        print("pushing coordinator: \(coordinator)")
		guard let root else {
			print("Root is nil, cannot push coordinator")
			return
		}
		coordinator.root = root
		root.pushCoordinator(coordinator)
    }
    
    /// Default implementation of `push(_:)`, adding a route to the navigation path.
    /// - Parameter route: The `Routable` instance to be pushed onto the stack.
    func push<Route: Routable>(_ route: Route) {
		guard let root else {
			print("Root is nil, cannot push route")
			return
		}
        root.push(route)
		path.append(route)
    }
    
    /// Default implementation of `pop()`, removing the last item from the navigation path.
    func pop() {
		guard let root else {
			print("Root is nil, cannot pop route")
			return
		}
        root.pop()
		path.removeLast()
    }
    
    /// Default implementation of `popToRoot()`, removing all items from the navigation path.
    func popToRoot() {
		guard let root else {
			print("Root is nil, cannot pop to root")
			return
		}
		root.popLast(path.count)
    }
}

// MARK: - Private Helper

private extension Navigating {
    
    /// Pops the last `k` items from the navigation path.
    /// - Parameter k: The number of items to remove (default is 1).
    func popLast(_ k: Int = 1) {
        path.removeLast(k)
        root?.popLast(k)
    }
}
