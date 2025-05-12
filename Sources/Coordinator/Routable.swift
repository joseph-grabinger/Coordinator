//
//  Routable.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A protocol that represents a navigation route capable of producing a SwiftUI `View`.
@MainActor
public protocol Routable: Identifiable, Hashable, CustomStringConvertible {

    /// The type of SwiftUI `View` to be displayed when this route is active.
    associatedtype V: SwiftUI.View

    /// Unique identifier of route.
    nonisolated var id: String { get }

    /// The view associated with this route.
    ///
    /// This property is used to render the destination screen when the route is triggered.
    @ViewBuilder var view: V { get }
}

// MARK: - CustomStringConvertible

public extension Routable where ID: CustomStringConvertible {
    nonisolated var description: String {
        let typeName = String(describing: Self.self)
        return "\(typeName)(id: \"\(id)\")"
    }
}
