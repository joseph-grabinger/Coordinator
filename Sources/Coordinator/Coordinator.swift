//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A base class for handling navigation within a SwiftUI application.
/// - Note: This class conforms to `ObservableObject` and `Navigating` to enable state-driven navigation.
@MainActor
open class Coordinator<Route: Routable>: ObservableObject, Navigating {
    
    // MARK: - Public Properties
        
    /// The initial route that the coordinator starts with.
    public let initialRoute: Route
    
    /// The navigation path that keeps track of the active navigation stack.
    /// - Updates to this property modify the navigation state in the `NavigationStack` of the `RootCoordinatorView`.
    @Published public var path: NavigationPath
    
    /// A weak reference to the root coordinator, if available.
    public weak var root: (any Navigating)?

    /// Initializes a new coordinator with an initial route.
    /// - Parameters:
    ///   - initialRoute: The first route that should be displayed when this coordinator is activated.
    public init(initialRoute: Route) {
        self.initialRoute = initialRoute
        self.path = NavigationPath()
    }
}
