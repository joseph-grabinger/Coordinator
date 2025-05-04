//
//  RootCoordinator.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 25.03.25.
//

import SwiftUI

@MainActor
public final class RootStackCoordinator<Route: Routable>: StackCoordinating {

	// MARK: - Public Properties

	/// The root coordinator's root is always `nil`.
	public var root: (any StackCoordinating)? = nil

	/// The navigation path representing the current state of navigation.
	@Published public var path = NavigationPath()

	/// The initial route that this coordinator starts with.
	public let initialRoute: Route

	// MARK: - Initialization

	/// Initializes a new `RootCoordinator` with a given `Coordinator`.
	/// - Parameter coordinator: The initial `Coordinator` that this root coordinator manages.
	public init<C: StackCoordinating>(coordinator: C) where C.Route == Route {
		self.initialRoute = coordinator.initialRoute
        self.path = coordinator.path
		coordinator.root = self
	}

	// MARK: - Navigating Conformance

	/// Pushes a new `Coordinator` onto the navigation stack.
	/// - Parameter coordinator: The `Coordinator` instance to be added.
	public func pushCoordinator(_ coordinator: any StackCoordinating) {
        push(coordinator.initialRoute)
	}

	/// Pushes a new route onto the navigation stack.
	/// - Parameter route: The `Routable` instance representing the destination.
	public func push<R: Routable>(_ route: R) {
		path.append(route)
	}

	/// Pops the top-most view from the navigation stack.
	/// - This removes the last added route from the navigation path.
	public func pop() {
        guard !path.isEmpty else {
            print("Root path is empty, cannot pop route")
            return
        }
		path.removeLast()
	}

	/// Pops all views from the navigation stack except the root view.
	/// - This resets the navigation state back to the initial route.
	public func popToRoot() {
		path.removeLast(path.count)
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

// - MARK: Equatable Conformance

public extension RootStackCoordinator {
    nonisolated static func == (lhs: RootStackCoordinator<Route>, rhs: RootStackCoordinator<Route>) -> Bool {
        lhs.id == rhs.id
    }
}
