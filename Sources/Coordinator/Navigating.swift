//
//  Navigating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import Foundation

/// A protocol defining navigation behaviors for managing a SwiftUI `NavigationStack`.
/// - This protocol enables hierarchical navigation using coordinators and routes.
@MainActor
public protocol Navigating: ObservableObject {
    
    // MARK: - Properties
    
    /// The initial route that this navigator starts with.
    var initialRoute: any Routable { get }
    
    /// A weak reference to the parent navigator, if available.
    /// - This enables hierarchical navigation where child navigators can communicate with their parent.
    var parent: (any Navigating)? { get }
    
    /// The navigation path representing the current state of navigation.
    /// - Modifying this property updates the navigation stack in SwiftUI.
    var path: NavPath { get set }
    
    // MARK: - Methods

    /// Pushes a new `Coordinator` onto the navigation stack.
    /// - Parameter coordinator: The `Coordinator` instance to be added.
    func pushCoordinator(_ coordinator: Coordinator)
    
    /// Pushes a new route onto the navigation stack.
    /// - Parameter route: The `Routable` instance representing the destination.
    func push<Route: Routable>(_ route: Route)

    /// Pops the top-most view from the navigation stack.
    func pop()

    /// Pops all views of the current coordinator except the root view.
    /// - This effecitely only leaves the root of the current coordinator's navigation path.
    func popToRoot()
}

// MARK: - Default Implementations

public extension Navigating {
    
    /// Pushes a new `Coordinator` onto the navigation stack.
    /// - Ensures the coordinator has its initial route set and assigns it a parent if needed.
    /// - Calls `pushCoordinator(_:)` on the parent to maintain hierarchy.
    /// - Parameter coordinator: The `Coordinator` to push.
    func pushCoordinator(_ coordinator: Coordinator) {
        print("pushing coordinator: \(coordinator)")
        
        if coordinator.parent == nil {
            coordinator.parent = self
            print("setting parent of \(coordinator) to \(self)")
        }

        // Ensure the cordinator has its initial route in its path.
        if AnyRoutable(coordinator.initialRoute) != coordinator.path.value.first {
            coordinator.path.value = [AnyRoutable(coordinator.initialRoute)]
            print("Adding initial route to \(coordinator)")
        }
        
        path.append(coordinator.path)
        print("appending \(coordinator.path) to \(path)")
        parent?.pushCoordinator(coordinator)
    }
    
    /// Default implementation of `push(_:)`, adding a route to the navigation path.
    /// - Parameter route: The `Routable` instance to be pushed onto the stack.
    func push<Route: Routable>(_ route: Route) {
        path.append(AnyRoutable(route))
        parent?.push(route)
    }
    
    /// Default implementation of `pop()`, removing the last item from the navigation path.
    func pop() {
        path.removeLast()
        print("Path of \(self) post pop: \(path)")
        parent?.pop()
    }
    
    /// Default implementation of `popToRoot()`, removing all items from the navigation path.
    ///
    /// Only for the root (whose `parent` is `nil`) the entire path can poped
    /// since its `initialRoute` is used as a root of the `RootCoordinatorView`.
    func popToRoot() {
        guard path.count > 0 else { return }
        popLast(parent != nil ? path.count - 1 : path.count)
    }
}

// MARK: - Private Helper

private extension Navigating {
    
    /// Pops the last `k` items from the navigation path.
    /// - Parameter k: The number of items to remove (default is 1).
    func popLast(_ k: Int = 1) {
        path.removeLast(k)
        parent?.popLast(k)
    }
}
