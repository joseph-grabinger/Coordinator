//
//  Coordinating.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 07.05.25.
//

import Foundation

@MainActor
public protocol Coordinating: ObservableObject, Identifiable, Hashable, Equatable {

//    nonisolated id: String { get }

}

// MARK: - Hashable

extension Coordinating {

    public nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

extension Coordinating {

    public nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
