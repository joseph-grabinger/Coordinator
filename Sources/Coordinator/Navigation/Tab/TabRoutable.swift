//
//  TabRoutable.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 12.05.25.
//

import SwiftUI

/// A specialized `Routable` protocol for routes displayed within a `TabView`.
///
/// In addition to providing a destination `view`, conforming types must define a `label`
/// for use as the tab item in a `TabView`.
public protocol TabRoutable: Routable {

    /// The label used to represent this tab in a `TabView`.
    var label: Label<Text, Image> { get }
}
