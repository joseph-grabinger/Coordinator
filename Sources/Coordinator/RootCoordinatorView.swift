//
//  RootCoordinatorView.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A SwiftUI view that serves as the root coordinator, managing navigation within the app.
/// - Note: This view integrates with a `Navigating`-conforming coordinator to handle navigation.
public struct RootCoordinatorView<C, Route>: View where C: Coordinating, Route: Routable, C.Route == Route {

    // MARK: - Private Properties
    
    /// The root coordinator responsible for managing the `NavigationPath` that's bound to the `NavigationStack`.
	@StateObject private var rootCoordinator: RootCoordinator<Route>
    
    /// The initial coordinator on the stack.
    @ObservedObject private var coordinator: C
    
    // MARK: - Initialization

    /// Creates an instance of `RootCoordinatorView`.
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for managing navigation.
    public init(for coordinator: C) {
		_rootCoordinator = StateObject(wrappedValue: RootCoordinator(coordinator: coordinator))
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: $rootCoordinator.path) {
			rootCoordinator.initialRoute
                .navigationDestination(for: Route.self) { route in
					route
                }
                .sheet(item: $coordinator.sheet, onDismiss: { coordinator.dismiss(.modal) }) { $0 }
                .fullScreenCover(item: $coordinator.fullScreenCover, onDismiss: { coordinator.dismiss(.fullScreenCover) }) { $0 }

        }
    }
}

// MARK: - Preview

#Preview {
    CoordinatorPlayground()
}
