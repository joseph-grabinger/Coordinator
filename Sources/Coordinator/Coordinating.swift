//
//  Coordinating.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 07.05.25.
//

import Foundation

/// Base protocol that defines the shared behavior and identity requirements for all coordinators.
///
/// - Note: The default implementations of `Hashable` and `Equatable` rely on the `id` property.
@MainActor
public protocol Coordinating: ObservableObject, Identifiable, Hashable, CustomStringConvertible {

    /// Unique identifier of coordinator.
    nonisolated var id: String { get }
}

// MARK: - Equatable

public extension Coordinating {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

public extension Coordinating {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - CustomStringConvertible

public extension Coordinating where ID == String {
    nonisolated var description: String {
        let typeName = String(describing: Self.self)
        return "\(typeName)(id: \"\(id)\")"
    }
}
