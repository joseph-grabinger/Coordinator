//
//  Coordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A protocol defining navigation behaviors for managing a SwiftUI `NavigationStack`.
/// - This protocol enables hierarchical navigation using coordinators and routes.
@MainActor
public protocol Coordinating: ObservableObject, Identifiable, Hashable {
    associatedtype Route: Routable
    
    // MARK: - Properties
    
    /// The initial route that this navigator starts with.
    var initialRoute: Route { get }
    
    /// A weak reference to the root coordinator, if available.
	var root: (any Coordinating)? { get set }

    /// The navigation path representing the current state of navigation.
    var path: NavigationPath { get set }
    
    /// The route which is currently presented as a sheet, if any.
    var sheet: Route? { get set }
    
    /// The route which is currently presented as a full screen cover, if any.
    var fullScreenCover: Route? { get set }
    
    // MARK: - Methods
    
    /// Presents a new `Route` with the given `PresentationMode`.
    /// - Parameter route: The `Route` to present modally.
    func present<Route>(
        _ route: Route,
        as presentationStyle: ModalPresentationStyle
    )  where Route == Self.Route
    
    /// Dismisses the `View` currently presented using the given `PresentationStyle`.
    func dismiss(_ presentationStyle: ModalPresentationStyle)

    /// Pushes a new `Coordinator` onto the `NavigationStack`.
    /// - Parameter coordinator: The `Coordinator` instance to be added.
    func pushCoordinator(_ coordinator: any Coordinating)
    
    /// Pushes a new `Route` onto the `NavigationStack`.
    /// - Parameter route: The `Route` to push.
    func push<Route: Routable>(_ route: Route)

    /// Pops the top-most view from the navigation stack.
    func pop()

    /// Pops all views of the current `Coordinator`.
    /// - This effectively displays the current coordinator's `initialRoute`.
    func popToRoot()
}

// MARK: - Hashable Conformance

public extension Coordinating {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Default Implementations

public extension Coordinating {
    
    /// Default implementation of `present(_:)`, presenting a route modally with the given `ModalPresentationStyle`.
    /// - Parameters:
    ///   - route: The `Routable` instance to present.
    ///   - presentationStyle: The `ModalPresentationStyle` to present the route with.
    func present<Route>(
        _ route: Route,
        as presentationStyle: ModalPresentationStyle
    ) where Route == Self.Route {
        switch presentationStyle {
        case .sheet:
            sheet = route
        case .fullScreenCover:
            fullScreenCover = route
        }
    }
    
    /// Default implementation of `dismiss(_:)`, dismissing the current route with the given `ModalPresentationStyle`.
    /// - Parameter presentationStyle: The `View` with the `ModalPresentationStyle` to dismiss.
    func dismiss(_ presentationStyle: ModalPresentationStyle) {
        switch presentationStyle {
        case .sheet:
            sheet = nil
        case .fullScreenCover:
            fullScreenCover = nil
        }
    }
    
    /// Default implementation of `pushCoordinator(_:)`, adding a coordinator to the `NavigationPath`.
    /// - Parameter coordinator: The `Coordinator` to push.
    func pushCoordinator(_ coordinator: any Coordinating) {
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
    
    /// Default implementation of `pop()`, removing the last item from the `NavigationPath`.
    func pop() {
		guard let root else {
			print("Root is nil, cannot pop route")
			return
		}
        root.pop()
        guard path.count >= 1 else { return }
		path.removeLast()
    }
    
    /// Default implementation of `popToRoot()`, removing all items from the `NavigationPath`.
    func popToRoot() {
		guard let root else {
			print("Root is nil, cannot pop to root")
			return
		}
		root.popLast(path.count)
        path = NavigationPath()
    }
}

// MARK: - Private Helper

private extension Coordinating {
    
    /// Pops the last `k` items from the navigation path.
    /// - Parameter k: The number of items to remove (default is 1).
    func popLast(_ k: Int = 1) {
        path.removeLast(k)
    }
}
