//
//  NavigationPathManager.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 25.03.25.
//

import SwiftUI
import OSLog

/// A concrete implementation of `StackNavigating` that manages the `NavigationPath` in a `NavigationStack`.
public final class NavigationPathManager<R: Routable>: StackNavigating {
    
    // MARK: - Internal Properties
    
    /// The navigation path representing the current state of navigation.
    @Published var path = NavigationPath() {
        willSet {
            guard newValue.count < path.count else { return }
            guard let topMostCoordinator = transitionIndices.values.max(by: { $0.index < $1.index })?.coordinator else { return }
            shouldPop = topMostCoordinator.shouldPop?() ?? true
        }
        didSet {
            defer { shouldPop = true }
            guard path.count < oldValue.count else { return }
            if !shouldPop {
                path = oldValue
                print("aborting pop")
                return
            }
            transitionIndices = transitionIndices.filter { _, transition in
                return transition.index <= path.count - 1 || transition.index == initialCoordinatorIndex
            }
        }
    }

    /// A dictionary holding the transition indices of the pushed coordinators.
    ///
    /// The key is the `StackCoordinating`-conforming coordinator's ID.
    /// And the value corresponds to the index of the coordinator's `initialRoute` within the `path`.
    private(set) var transitionIndices = [String: (coordinator: any StackCoordinating, index: Int)]()

    /// The initial route that this coordinator starts with.
    let initialRoute: R
    
    // MARK: - Private Properties
    
    /// A constant for the transition index of the initial coordinator.
    private let initialCoordinatorIndex = -1

    /// A flag indicating whether the next route should be popped of the stack.
    private var shouldPop = true

    // MARK: - Initialization
    
    /// Initializes a new `NavigationPathManager` with the  given coordinator.
    /// - Parameter coordinator: A initial stack-based coordinator.
    public init<C: StackCoordinating>(coordinator: C) where C.Route == R {
        self.initialRoute = coordinator.initialRoute
        transitionIndices[coordinator.id] = (coordinator, initialCoordinatorIndex)
        coordinator.root = self
    }
}

// MARK: StackNavigating

public extension NavigationPathManager {
    
    func pushCoordinator(_ coordinator: any StackCoordinating) {
        coordinator.root = self
        transitionIndices[coordinator.id] = (coordinator, path.count)
        pushRoute(coordinator.initialRoute)
    }
    
    func pushRoute<Route: Routable>(_ route: Route) where Route : Routable {
        path.append(route)
    }
    
    func popRoute(count: Int) {
        guard path.count >= count else {
            Logger.coordinator.warning("\(self) cannot pop \(count) routes: path contains only \(self.path.count).")
            return
        }
        path.removeLast(count)
    }
    
    func popCoordinator(_ coordinator: any StackCoordinating) {
        guard let transitionIndex = transitionIndices[coordinator.id]?.index else {
            Logger.coordinator.warning("\(self) cannot pop coordinator \(coordinator.description): no transition index found.")
            return
        }
        guard transitionIndex != initialCoordinatorIndex else {
            Logger.coordinator.warning("\(self) cannot pop coordinator \(coordinator.description): as it's the initial coordinator.")
            return
        }
        let routesToPop = path.count - transitionIndex
        popRoute(count: routesToPop)
    }
    
    func popToInitialRoute(of coordinator: any StackCoordinating) {
        guard let transitionIndex = transitionIndices[coordinator.id]?.index else {
            Logger.coordinator.warning("\(self) cannot pop to initial route of \(coordinator.description): no transition index found.")
            return
        }
        if transitionIndex == initialCoordinatorIndex {
            popToRoot()
        } else {
            let routesToPop = path.count - transitionIndex - 1
            popRoute(count: routesToPop)
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
        transitionIndices = transitionIndices.filter { _, transition in
            return transition.index == initialCoordinatorIndex
        }
    }
}
