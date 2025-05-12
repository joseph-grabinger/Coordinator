//
//  TabViewCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import OSLog

/// A protocol that defines the coordination logic of a `TabView`.
///
/// Conforming types are responsible for managing a set of available tabs and the currently selected tab.
public protocol TabViewCoordinating: Coordinating {

    /// The type representing an individual tab route.
    associatedtype TabRoute: TabRoutable

    // MARK: - Properties

    /// The currently selected tab route.
    ///
    /// This property reflects the active tab in the `TabView`, and updates when the user switches tabs.
    var selectedTab: TabRoute { get set }

    /// The list of all available tab routes.
    ///
    /// These routes are displayed in the `TabView`. The coordinator manages this list and determines
    /// whether a tab selection is valid based on its contents.
    var tabs: [TabRoute] { get }
}

// MARK: - Convenience Methods

public extension TabViewCoordinating {

    /// Selects the given tab route if it exists in the list of registered tabs.
    ///
    /// This method updates `selectedTab` if the provided tab is part of the `tabs` collection.
    /// If the tab is not registered, a warning is logged and the selection is ignored.
    ///
    /// - Parameter tabRoute: The tab route to select.
    func select(_ tabRoute: TabRoute) {
        guard tabs.contains(tabRoute) else {
            Logger.navKit.warning("Attempted to select unregistered tab: \(tabRoute))")
            return
        }
        selectedTab = tabRoute
    }
}
