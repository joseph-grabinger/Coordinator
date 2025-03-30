//
//  ChildDestinationsViewModifier.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 30.03.25.
//

import SwiftUI

/// A `ViewModifier` that recursively applies navigation destinations from a list of `Coordinating` children.
struct ChildDestinationsViewModifier: ViewModifier {
    /// A list of child coordinators  for which navigation destinations should be defined.
    var children: [any Coordinating]
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        applyNavigationDestinations(to: content, from: children)
    }

    // MARK: - Private Methods
    
    /// Recursively applies navigation destinations to the content based on the provided children.
    /// - Parameters:
    ///   - content: The content view to which the navigation destinations will be applied.
    ///   - children: A list of child coordinators used to define the navigation destinations.
    /// - Returns: A view with applied navigation destinations.
    @ViewBuilder
    private func applyNavigationDestinations(to content: some View, from children: [any Coordinating]) -> some View {
        if let firstChild = children.first {
            AnyView(applyNavigationDestination(for: firstChild, to: content))
                .modifier(ChildDestinationsViewModifier(children: Array(children.dropFirst())))
        } else {
            content
        }
    }
    
    /// Applies a navigation destination for a given child coordinator to the content view.
    ///
    /// - Parameters:
    ///   - child: The child coordinator whose route will be used to apply the navigation destination.
    ///   - content: The content view to which the navigation destination will be applied.
    /// - Returns: A view with the applied navigation destination for the specified child.
    private func applyNavigationDestination<C: Coordinating>(for child: C, to content: some View) -> some View {
        content.navigationDestination(for: C.Route.self) { route in
            route
        }
    }
}
