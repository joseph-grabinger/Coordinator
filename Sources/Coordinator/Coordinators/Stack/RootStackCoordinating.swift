//
//  RootStackCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 25.03.25.
//

import SwiftUI

public protocol RootStackCoordinating: StackCoordinating {

    var path: NavigationPath { get set }

    /// Pushes a new `Route` onto the `NavigationStack`.
    ///
    /// > The `Route` type is not bound to any coordinator's associated type. Thus, `any Routable`can be pushed.
    ///
    /// - Parameter route: The `Route` to push.
    func push<Route: Routable>(_ route: Route)
}

// MARK: - Default Implementations

public extension RootStackCoordinating {
    
    // MARK: - Properties
    
    /// The `root` is always `nil` for root stack coordinators.
    var root: (any RootStackCoordinating)? {
        get { nil }
        set { }
    }

    var presentedRoutes: [Route] {
        get { [] }
        set { }
    }

    // MARK: - Methods

    /// Pushes a new `Coordinator` onto the navigation stack.
    /// - Parameter coordinator: The `StackCoordinating`-conforming instance to be added.
    func push(coordinator: any StackCoordinating) {
        push(coordinator.initialRoute)
    }
    
    /// Pushes a new route onto the navigation stack.
    /// - Parameter route: The `Routable` instance representing the destination.
    func push<Route: Routable>(_ route: Route) {
        path.append(route)
    }
    
    /// Pops the top-most view from the navigation stack.
    /// - This removes the last added route from the navigation path.
    func pop() {
        guard !path.isEmpty else {
            print("Root path is empty, cannot pop route")
            return
        }
        path.removeLast()
    }
    
    /// Pops all views from the navigation stack except the root view.
    /// - This resets the navigation state back to the initial route.
    func popToRoot() {
        path = NavigationPath()
    }

    /// Pops the last `k` views from the navigation stack.
    /// - Parameter k: The number of views to pop, defaulting to `1`.
    func popLast(_ k: Int = 1) {
        guard path.count >= k else {
            print("Root path contains \(path.count) elements, cannot pop \(k) routes")
            return
        }
        path.removeLast(k)
    }
}

// MARK: - RootStackCoordinator

public final class RootStackCoordinator<Route: Routable>: RootStackCoordinating {

	// MARK: - Public Properties

	/// The navigation path representing the current state of navigation.
	@Published public var path = NavigationPath()

	/// The initial route that this coordinator starts with.
    public let initialRoute: Route

	// MARK: - Initialization

	/// Initializes a new `RootCoordinator` with a given `Coordinator`.
	/// - Parameter coordinator: The initial `Coordinator` that this root coordinator manages.
	public init<C: StackCoordinating>(coordinator: C) where C.Route == Route {
		self.initialRoute = coordinator.initialRoute
        self.path = NavigationPath(coordinator.presentedRoutes)
		coordinator.root = self
	}
}
