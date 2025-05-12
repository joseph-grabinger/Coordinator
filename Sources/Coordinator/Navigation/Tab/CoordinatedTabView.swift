//
//  CoordinatedTabView.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

/// A SwiftUI view that displays a tab-based interface managed by a `TabViewCoordinating` coordinator.
///
/// This view connects a coordinator conforming to `TabViewCoordinating` with a `TabView`,
/// automatically rendering each registered tab and updating the selection as needed.
///
/// - Note: This view relies on the coordinator to provide tab routes and manage tab selection.
public struct CoordinatedTabView<Coordinator: TabViewCoordinating>: View {

    // MARK: - Private Properties

    /// The coordinator that manages the tab state and routes.
    @ObservedObject private var coordinator: Coordinator

    // MARK: - Initialization

    /// Creates a `CoordinatedTabView` bound to a given coordinator.
    ///
    /// - Parameter coordinator: The coordinator responsible for providing tab routes and managing selection.
    public init(for coordinator: Coordinator) {
        self._coordinator = ObservedObject(wrappedValue: coordinator)
    }

    // MARK: - View Body

    public var body: some View {
        #if canImport(SwiftUI.Tab)
        TabView(selection: $coordinator.selectedTab) {
            ForEach(coordinator.tabs, id: \.self) { tabRoute in
                Tab {
                    tabRoute
                } label: {
                    tabRoute.label
                }
                .tag(tabRoute)
            }
        }
        #else
        TabView(selection: $coordinator.selectedTab) {
            ForEach(coordinator.tabs, id: \.self) { tabRoute in
                tabRoute.view
                    .tabItem { tabRoute.label }
                    .tag(tabRoute)
            }
        }
        #endif
    }
}
