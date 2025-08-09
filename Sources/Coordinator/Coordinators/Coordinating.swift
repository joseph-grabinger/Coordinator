//
//  Coordinating.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 07.05.25.
//

import Foundation

/// Base protocol that defines the shared behavior and identity requirements for all coordinators.
@MainActor
public protocol Coordinating: ObservableObject, Identifiable, Hashable, Equatable {

    /// The unique identifier of the coordinator.
    nonisolated var id: String { get }

}

// MARK: - Hashable

public extension Coordinating {

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

public extension Coordinating {

    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
