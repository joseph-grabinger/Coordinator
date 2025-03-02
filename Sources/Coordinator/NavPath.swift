//
//  NavPath.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

/// A structure representing a navigation path used to track the navigation state within a `NavigationStack`.
/// - Stores a sequence of `AnyRoutable` instances to define the navigation history.
public struct NavPath {
    
    // MARK: - Public Properties
    
    /// The list of routable items representing the navigation stack.
    var value: [AnyRoutable]
    
    /// The number of items that were initially part of the navigation path.
    /// - This helps track the original number of routes before modifications.
    var prefixCount: Int
    
    /// The current number of items in the navigation path.
    var count: Int {
        value.count
    }
    
    // MARK: - Initialization
    
    /// Creates a new navigation path with an optional initial set of routable items.
    /// - Parameter value: An array of `AnyRoutable` items representing the initial navigation state.
    init(_ value: [AnyRoutable] = []) {
        self.value = value
        self.prefixCount = value.count
    }
    
    // MARK: - Public Methods

    /// Appends a new routable item to the navigation path.
    /// - Parameter value: The `AnyRoutable` instance to add.
    mutating func append(_ value: AnyRoutable) {
        self.value.append(value)
        self.prefixCount += 1
    }
    
    /// Appends an entire `NavPath` to the current path.
    /// - This effectively merges another navigation path into the existing one.
    /// - Parameter path: The `NavPath` to append.
    mutating func append(_ path: NavPath) {
        self.value.append(contentsOf: path.value)
    }
    
    /// Removes a specific navigation path from the end of the current path.
    /// - Parameter path: The `NavPath` to remove.
    mutating func remove(_ path: NavPath) {
        self.value.removeLast(path.count)
        self.prefixCount -= 1
    }
    
    /// Removes the last `k` items from the navigation path.
    /// - Parameter k: The number of items to remove (default is 1).
    mutating func removeLast(_ k: Int = 1) {
        self.value.removeLast(k)
        self.prefixCount -= k
    }
}
