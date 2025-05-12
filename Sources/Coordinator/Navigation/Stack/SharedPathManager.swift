//
//  File.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 12.05.25.
//

import SwiftUI

/// A concrete implementation of `SharedPathManaging` that manages the navigation path and initial route.
public final class SharedPathManager<Route: Routable>: SharedPathManaging {

    // MARK: - Public Properties

    /// The initial route of the navigation stack.
    public let initialRoute: Route

    /// The navigation path representing current state.
    @Published public var path = NavigationPath()

    // MARK: - Initialization

    /// Initializes a new navigation path manager with the given coordinator.
    /// - Parameter coordinator: A stack-based coordinator.
    public init<C: StackCoordinating>(coordinator: C) where C.Route == Route {
        self.initialRoute = coordinator.initialRoute
        self.path = NavigationPath(coordinator.presentedRoutes)
        coordinator.root = self
    }
}
