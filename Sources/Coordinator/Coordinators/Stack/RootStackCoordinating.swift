//
//  RootStackCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 25.03.25.
//

import SwiftUI
import OSLog

/// A concrete implementation of `RootStackCoordinating` that manages the `NavigationPath` and initial route.
public final class RootStackCoordinator<R: Routable>: StackNavigating {

	// MARK: - Public Properties

	/// The navigation path representing the current state of navigation.
    @Published public var path = NavigationPath() {
        didSet {
            guard path.count < oldValue.count else { return }
            transitionPoints = transitionPoints.filter { _, index in
                return index <= path.count - 1
            }
        }
    }
    
    /// A dictionary holding the transition points of the pushed coordinators.
    ///
    /// The key is the `StackCoordinating`-conforming coordinator's ID.
    /// And the value corresponds to the index  coordinator's `initialRoute` within the `path`.
    private(set) var transitionPoints = [String: Int]()

	/// The initial route that this coordinator starts with.
    public let initialRoute: R

	// MARK: - Initialization

	/// Initializes a new `RootStackCoordinator` with the  given coordinator.
	/// - Parameter coordinator: A initial stack-based coordinator.
	public init<C: StackCoordinating>(coordinator: C) where C.Route == R {
		self.initialRoute = coordinator.initialRoute
		coordinator.root = self
	}
    
    // MARK: Public Methods
    
    public func pushCoordinator(_ coordinator: any StackCoordinating) {
        coordinator.root = self
        transitionPoints[coordinator.id] = path.count
        pushRoute(coordinator.initialRoute)
    }
    
    public func pushRoute<Route: Routable>(_ route: Route) where Route : Routable {
        path.append(route)
    }
    
    public func popRoute(count: Int) {
        guard path.count >= count else {
            Logger.coordinator.warning("\(self) cannot pop \(count) routes: path contains only \(self.path.count).")
            return
        }
        path.removeLast(count)
    }
    
    public func popToRoot() {
        path = NavigationPath()
        transitionPoints = [:]
    }
}
