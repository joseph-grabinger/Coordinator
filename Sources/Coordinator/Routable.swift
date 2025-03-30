//
//  Routable.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI

/// A protocol defining a navigation route that can produce a SwiftUI `View`.
public protocol Routable: View, Hashable, Identifiable {}
