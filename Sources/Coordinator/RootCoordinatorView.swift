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
    
    /// The root coordinator responsible for managing the `NavigationPath` that's bound to the `NavigationStack`.
	@StateObject private var rootCoordinator: RootCoordinator<Route>

    /// Creates an instance of `RootCoordinatorView`.
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for managing navigation.
    public init(for coordinator: C) {
		_rootCoordinator = StateObject(wrappedValue: RootCoordinator(coordinator: coordinator))
    }
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: $rootCoordinator.path) {
			rootCoordinator.initialRoute
                .navigationDestination(for: AnyRoutable.self) { route in
					AnyView(route.route)
                }
        }
        .environmentObject(rootCoordinator)
    }
}

// MARK: - Preview

#Preview {
    CoordinatorPlayground()
}
