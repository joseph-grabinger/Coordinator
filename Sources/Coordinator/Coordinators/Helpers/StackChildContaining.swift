//
//  StackChildContaining.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 04.05.25.
//

/// A protocol defining the requirements for `TabViewCoordinating`-conforming objects containing a `StackCoordinating`-conforming object.
public protocol StackChildContaining {
    /// The type representing a tab route.
    associatedtype Route: TabRoutable
    
    /// Returns the coordinator which is responsible for managing the given `tab`'s `NavigationStack`.
    /// - Parameter tab: The tab for which the coordiantor should be returned.
    /// - Returns: The coordiantor for the tab.
    func coordinator(for tab: Route) -> (any StackCoordinating)?
}
