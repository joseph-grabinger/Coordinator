//
//  TabViewCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

/// A protocol that defines the coordination logic for a tab-based navigation system.
///
/// Conforming types are responsible for managing a set of tabs and handling tab selection.
@MainActor
public protocol TabViewCoordinating: Coordinating {
    /// The type representing a tab route.
    associatedtype Route: TabRoutable
    
    // MARK: - Properties

    /// The currently selected tab.
    var selectedTab: Route { get set }
    
    /// The list of displayed tabs.
    var tabs: [Route] { get }
    
    // MARK: - Methods
    
    /// Selects the specified tab.
    /// - Parameter tab: The tab to be selected.
    func select(_ tab: Route)
}

// MARK: - Hashable Conformance

public extension TabViewCoordinating {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Default Implementation

public extension TabViewCoordinating {
    
    /// Default implementation of the `select(_:)` method, selecting the given `tab`.
    ///
    /// Attempts to select a tab. If the tab is not part of the registered `tabs`,
    /// a warning is printed and no selection is made.
    /// - Parameter tab: The tab to select.
    func select(_ tab: Route) {
        guard tabs.contains(tab) else {
            print("Can't select tab: \(tab) since it's not registered in the Coordinator's tabs.")
            return
        }
        selectedTab = tab
    }
}
