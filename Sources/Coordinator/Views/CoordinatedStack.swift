//
//  CoordinatedStack.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A SwiftUI view that serves as the root coordinator, managing navigation within the app.
/// - Note: This `View` integrates with a `StackCoordinating`-conforming coordinator to handle navigation.
public struct CoordinatedStack<Coordinator: StackCoordinating>: View {

    // MARK: - Private Properties
    
    /// The root coordinator responsible for managing the `NavigationPath` that's bound to the `NavigationStack`.
    @StateObject private var rootCoordinator: RootStackCoordinator<Coordinator.Route>
    
    /// The initial coordinator on the stack.
    @ObservedObject private var coordinator: Coordinator
    
    // MARK: - Initialization

    /// Creates an instance of `RootCoordinatorView`.
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for managing navigation.
    public init(for coordinator: Coordinator) {
		_rootCoordinator = StateObject(wrappedValue: RootStackCoordinator(coordinator: coordinator))
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: $rootCoordinator.path) {
			rootCoordinator.initialRoute
                .navigationDestination(for: Coordinator.Route.self) { $0 }
//                .sheet(
//                    item: $coordinator.sheet,
//                    onDismiss: { coordinator.dismiss(.sheet) }
//                ) { $0 }
//                .fullScreenCover(
//                    item: $coordinator.fullScreenCover,
//                    onDismiss: { coordinator.dismiss(.fullScreenCover) }
//                ) { $0 }
        }
    }
}
