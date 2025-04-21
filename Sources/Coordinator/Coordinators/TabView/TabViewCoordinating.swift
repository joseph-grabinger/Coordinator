//
//  TabViewCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

@MainActor
public protocol TabViewCoordinating: ObservableObject, Identifiable, Hashable {
    associatedtype Route: TabRoutable
    
    var selectedTab: Route { get set }
    
    var tabs: [Route] { get }
}

// MARK: - Hashable Conformance

public extension TabViewCoordinating {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
