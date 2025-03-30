//
//  Routable.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A protocol defining a navigation route that can produce a SwiftUI `View`.
public protocol Routable: View, Hashable, Identifiable {}

// MARK: - AnyRoutable

/// A type-erased wrapper for any `Routable` type, enabling storage and navigation of routes
/// without requiring a concrete type.
/// - Note: This allows SwiftUI's `NavigationStack` to work with heterogeneous route types.
public struct AnyRoutable: Hashable {

	// MARK: - Internal Properties

	/// The underlying `Routable` instance, stored as an opaque type.
	let route: any Routable

	// MARK: - Private Properties

	/// A unique identifier for the route, allowing it to be used in SwiftUI navigation.
	private let id: AnyHashable

	// MARK: - Initialization

	/// Creates an instance of `AnyRoutable` from a concrete `Routable` type.
	/// - Parameter route: The concrete route conforming to `Routable`.
	init<Route: Routable>(route: Route) {
		self.route = route
		self.id = route
	}

	// MARK: - Hashable Conformance

	public static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
