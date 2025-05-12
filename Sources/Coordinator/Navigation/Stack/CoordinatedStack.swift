//
//  CoordinatedStack.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A SwiftUI view that creates a `NavigationStack` driven by a `StackCoordinating` coordinator.
public struct CoordinatedStack<Coordinator: StackCoordinating>: View {

    // MARK: - Private Properties

    /// The root path manager that drives the `NavigationStack`.
    @StateObject private var rootCoordinator: SharedPathManager<Coordinator.Route>

    // MARK: - Initialization

    /// Initializes a new `CoordinatedStack` with the given coordinator.
    /// - Parameter coordinator: The coordinator responsible for navigation.
    public init(for coordinator: Coordinator) {
        _rootCoordinator = StateObject(wrappedValue: SharedPathManager(coordinator: coordinator))
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack(path: $rootCoordinator.path) {
            rootCoordinator.initialRoute.view
                .navigationDestination(for: Coordinator.Route.self) { $0.view }
        }
    }
}
