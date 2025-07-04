//
//  CoordinatedTabView.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

/// A view that displays a tab-based interface coordinated by a `TabViewCoordinating` instance.
/// - Note: This `View` integrates with a `TabViewCoordinating`-conforming coordinator to handle navigation.
public struct CoordinatedTabView<Coordinator: TabViewCoordinating>: View {
    
    // MARK: - Private Properties

    /// The coordinator of the tab view.
    @ObservedObject private var coordinator: Coordinator
    
    // MARK: - Initialization

    /// Creates an instance of `CoordinatedTabView`.
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for managing the `TabView`.
    public init(for coordinator: Coordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    // MARK: - Body

    public var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            ForEach(coordinator.tabs, id: \.self) { tab in
                tab
                    .tabItem { tab.label }
                    .tag(tab)
            }
        }
    }
}
