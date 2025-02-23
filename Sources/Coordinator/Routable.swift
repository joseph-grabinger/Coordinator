//
//  Routable.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A protocol defining a navigation route that can produce a SwiftUI `View`.
/// - Note: Conforming types must provide a way to build their corresponding view.
@MainActor
public protocol Routable: Hashable {
    associatedtype Destination: View
    
    /// Builds and returns the view associated with the route.
    @ViewBuilder
    func buildView() -> Destination
}

/// A type-erased wrapper for any `Routable` type, enabling storage and navigation of routes
/// without requiring a concrete type.
/// - Note: This allows SwiftUI's `NavigationStack` to work with heterogeneous route types.
public struct AnyRoutable: Hashable {

    // MARK: - Private Properties

    /// The underlying `Routable` instance, stored as an opaque type.
    private let route: any Routable
    
    /// A unique identifier for the route, allowing it to be used in SwiftUI navigation.
    private let id: AnyHashable

    // MARK: - Initialization
    
    /// Creates an instance of `AnyRoutable` from a concrete `Routable` type.
    /// - Parameter route: The concrete route conforming to `Routable`.
    init<Route: Routable>(_ route: Route) {
        self.route = route
        self.id = route
    }

    // MARK: - Public Methods
    
    /// Builds the SwiftUI view for the stored route.
    /// - Returns: An `AnyView` representing the destination view.
    @MainActor
    func buildView() -> some View {
        AnyView(route.buildView())
    }
    
    // MARK: - Conformance to Hashable

    public static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
