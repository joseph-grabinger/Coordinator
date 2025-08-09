//
//  RootStackCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 25.03.25.
//

import SwiftUI
import OSLog

/// A protocol that defines an object responsible of managing the underlying `NavigationPath` in any stack-based navigation.
@MainActor
public protocol RootStackCoordinating: ObservableObject, CustomStringConvertible {

    /// The SwiftUI `NavigationPath` representing current navigation state.
    var path: NavigationPath { get set }
}

// MARK: - Navigation Methods

public extension RootStackCoordinating {

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
    
    /// Pops the top-most route from the navigation stack.
    func pop() {
        popLast(1)
    }
    
    /// Pops all views from the `NavigationStack` - leaving only the initial route.
    ///
    /// This effectively empties the `NavigationPath`.
    func popToRoot() {
        path = NavigationPath()
    }

    /// Pops the last `k` views from the navigation stack.
    /// - Parameter k: The number of views to pop, defaulting to `1`.
    func popLast(_ k: Int = 1) {
        guard path.count >= k else {
            Logger.coordinator.warning("\(self) cannot pop \(k) routes: path contains only \(self.path.count).")
            return
        }
        path.removeLast(k)
    }
}


// MARK: - CustomStringConvertible

public extension RootStackCoordinating {
    
    nonisolated var description: String {
        let typeName = String(describing: Self.self)
        let objectID = ObjectIdentifier(self)
        return "\(typeName)(objectID: \"\(objectID)\")"
    }
}

// MARK: - RootStackCoordinator

/// A concrete implementation of `RootStackCoordinating` that manages the `NavigationPath` and initial route.
public final class RootStackCoordinator<Route: Routable>: RootStackCoordinating {

	// MARK: - Public Properties

	/// The navigation path representing the current state of navigation.
	@Published public var path = NavigationPath()

	/// The initial route that this coordinator starts with.
    public let initialRoute: Route

	// MARK: - Initialization

	/// Initializes a new `RootStackCoordinator` with the  given coordinator.
	/// - Parameter coordinator: A initial stack-based coordinator.
	public init<C: StackCoordinating>(coordinator: C) where C.Route == Route {
		self.initialRoute = coordinator.initialRoute
        self.path = NavigationPath(coordinator.presentedRoutes)
		coordinator.root = self
	}
}
