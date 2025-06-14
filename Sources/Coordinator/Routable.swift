//
//  Routable.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A protocol defining a navigation route that can produce a SwiftUI `View`.
public protocol Routable: View, Hashable, Identifiable {}

// - MARK: TabRoutable

/// A protocol defining a navigation route for a `TabView` which can produce a SwiftUI `View`.
public protocol TabRoutable: Routable {
    /// The label to use for the `Tab`.
    var label: Label<Text, Image> { get }
}
