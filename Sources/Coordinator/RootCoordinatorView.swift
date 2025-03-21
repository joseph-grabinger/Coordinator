//
//  RootCoordinatorView.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//



import SwiftUI

/// A SwiftUI view that serves as the root coordinator, managing navigation within the app.
/// - Note: This view integrates with a `Navigating`-conforming coordinator to handle navigation.
public struct RootCoordinatorView<C, Route>: View where C: Coordinator<Route>, Route: Routable {
    
    // MARK: - Private Properties
    
    /// The coordinator responsible for handling navigation events.
    @ObservedObject private var coordinator: C
    
    /// Creates an instance of `RootCoordinatorView`.
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for managing navigation.
    public init(for coordinator: C) {
        self.coordinator = coordinator
    }
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.initialRoute
                .navigationDestination(for: Route.self) { route in
                    route
                }
        }
        .environmentObject(coordinator)
    }
}

// MARK: - Preview

#Preview {
    CoordinatorPlayground()
}
