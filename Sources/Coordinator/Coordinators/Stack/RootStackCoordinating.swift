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
	@Published public var path = NavigationPath()

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
    }
}
