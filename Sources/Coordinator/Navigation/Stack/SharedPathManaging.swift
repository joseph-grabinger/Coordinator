//
//  SharedPathManaging.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 25.03.25.
//

import SwiftUI
import OSLog

/// A protocol that defines a shared navigation path manager, used for coordinating stack-based navigation.
@MainActor
public protocol SharedPathManaging: ObservableObject, CustomStringConvertible {

    /// The SwiftUI navigation path representing current navigation state.
    var path: NavigationPath { get set }
}

// MARK: - Navigation Methods

public extension SharedPathManaging {

    /// Pushes a new route onto the navigation stack.
    /// - Parameter route: A route conforming to `Routable`.
    func pushRoute<Route: Routable>(_ route: Route) {
        path.append(route)
    }

    /// Pushes a new coordinator's initial route onto the navigation stack.
    /// - Parameter coordinator: A stack-based coordinator.
    func pushCoordinator(_ coordinator: any StackCoordinating) {
        pushRoute(coordinator.initialRoute)
    }

    /// Pops the top-most route.
    func pop() {
        popLast(1)
    }

    /// Pops all routes and resets to the initial route.
    func popToRoot() {
        path = NavigationPath()
    }

    /// Pops the last `k` routes.
    /// - Parameter k: Number of routes to pop.
    func popLast(_ k: Int = 1) {
        guard path.count >= k else {
            Logger.navKit.warning("\(self) cannot pop \(k) routes: path contains only \(self.path.count)")
            return
        }
        path.removeLast(k)
    }
}

// MARK: - CustomStringConvertible

public extension SharedPathManaging {
    nonisolated var description: String {
        let typeName = String(describing: Self.self)
        let objectID = ObjectIdentifier(self)
        return "\(typeName)(objectID: \"\(objectID)\")"
    }
}
