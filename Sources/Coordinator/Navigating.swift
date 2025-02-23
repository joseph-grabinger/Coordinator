//
//  Navigating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import Foundation
import Combine

/// A protocol defining navigation behaviors for managing a SwiftUI `NavigationStack`.
@MainActor
public protocol Navigating: ObservableObject {
    
    var initialRoute: any Routable { get }
    
    /// The navigation path representing the current state of navigation.
    var path: NavPath { get set }
    
    var cancelBag: Set<AnyCancellable> { get set }
    
    /// Pushes a new `Coordinator` onto the navigation stack.
    func pushCoordinator(_ coordinator: Coordinator)
    
    /// Pushes a new route onto the navigation stack.
    /// - Parameter route: The `Routable` instance representing the destination.
    func push<Route: Routable>(_ route: Route)

    /// Pops the top-most view from the navigation stack.
    func pop()

    /// Pops all views, returning to the root of the navigation stack.
    func popToRoot()
}

public extension Navigating {
    
    func pushCoordinator(_ coordinator: Coordinator) {
        print("pushing coordinator: \(coordinator)")

        // Ensure the cordinator has its initial rout in its path.
        if AnyRoutable(coordinator.initialRoute) != coordinator.path.value.first {
            coordinator.path.value = [AnyRoutable(coordinator.initialRoute)]
        }
        
        let startIndex = coordinator.path.count
        
        coordinator.$path
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                print("start Index: \(startIndex), path count: \(self.path.count)")
                print("LISTENER: \(self.path.value), newValue: \(newValue)")
                    let appendixRange = (startIndex)...(self.path.count-1)
                    print("range: \(appendixRange)")
                    self.path.value.replaceSubrange(appendixRange, with: newValue.value)
                
                if newValue.value.isEmpty {
                    print("canceled subs")
                    cancelBag.forEach { $0.cancel() }
                    cancelBag = []
                }
            }
            .store(in: &cancelBag)
        
        path.append(coordinator.path)
        print("appending \(coordinator.path) to \(path)")
    }
    
    /// Default implementation of `push(_:)`, adding a route to the navigation path.
    /// - Parameter route: The `Routable` instance to be pushed onto the stack.
    func push<Route: Routable>(_ route: Route) {
        path.append(AnyRoutable(route))
    }
    
    /// Default implementation of `pop()`, removing the last item from the navigation path.
    func pop() {
        path.removeLast()
        print("Path post pop: \(path)")
    }
    
    /// Default implementation of `popToRoot()`, removing all items from the navigation path.
    func popToRoot() {
        path.removeLast(path.count)
    }
}
