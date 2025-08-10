//
//  TabViewCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import OSLog

/// A protocol that defines the coordination logic for a tab-based navigation system.
///
/// Conforming types are responsible for managing a set of tabs and handling tab selection.
public protocol TabViewCoordinating: Coordinating {

    /// The type representing a tab route.
    associatedtype Route: TabRoutable
    
    // MARK: - Properties

    /// The currently selected tab.
    ///
    /// This property reflects the active tab in the `TabView`, and updates when the user switches tabs.
    var selectedTab: Route { get set }
    
    /// The list of displayed tabs.
    var tabs: [Route] { get }
}

// MARK: - Navigation Methods

public extension TabViewCoordinating {
    
    /// Selects the specified tab.
    ///
    /// This method updates `selectedTab` if the provided tab is part of the `tabs` collection.
    /// If the tab is not registered, a warning is logged and the selection is ignored.
    ///
    /// - Parameter tab: The tab `Route` to select.
    func select(_ tab: Route) {
        guard tabs.contains(tab) else {
            Logger.coordinator.warning("Cannot select tab from \"\(self)\": \"\(tab)\" is unregistered.")
            return
        }
        selectedTab = tab
    }
}
