//
//  CoordinatedStack.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A SwiftUI view that creates a `NavigationStack` driven by a `StackCoordinating`-conforming coordinator.
public struct CoordinatedStack<Coordinator: StackCoordinating>: View {

    // MARK: - Private Properties
    
    /// The object responsible for managing the `NavigationPath` that's bound to the `NavigationStack`.
    @StateObject private var pathManager: NavigationPathManager<Coordinator.Route>
    
    // MARK: - Initialization

    /// Creates an instance of `RootCoordinatorView`.
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for managing navigation.
    public init(for coordinator: Coordinator) {
		_pathManager = StateObject(wrappedValue: NavigationPathManager(coordinator: coordinator))
    }
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: $pathManager.path) {
			pathManager.initialRoute
                .navigationDestination(for: Coordinator.Route.self) { $0 }
        }
    }
}
