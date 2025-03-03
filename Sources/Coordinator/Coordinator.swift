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
open class Coordinator: ObservableObject, Navigating {
    
    // MARK: - Public Properties
        
    /// The initial route that the coordinator starts with.
    public let initialRoute: any Routable
    
    /// The navigation path that keeps track of the active navigation stack.
    /// - Updates to this property modify the navigation state in the `NavigationStack` of the `RootCoordinatorView`.
    @Published public var path: NavPath
    
    /// A weak reference to the parent coordinator, if available.
    /// - This allows for hierarchical navigation where child coordinators can communicate with their parent.
    public weak var parent: (any Navigating)?
    
    /// Initializes a new coordinator with an initial route.
    /// - Parameters:
    ///   - initialRoute: The first route that should be displayed when this coordinator is activated.
    ///   - pushInitialRoute: A Boolean value that determines whether to push the initial route onto the navigation stack.
    ///     - `true`: The `initialRoute` is added to `path` automatically.
    ///     - `false`: The navigation stack starts empty.
    public init(initialRoute: any Routable, pushInitialRoute: Bool = true) {
        self.initialRoute = initialRoute
        self.path = NavPath(pushInitialRoute ? [AnyRoutable(initialRoute)] : [])
    }
}
