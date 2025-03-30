//
//  ChildDestinationsViewModifier.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 30.03.25.
//

import SwiftUI

struct ChildDestinationsViewModifier: ViewModifier {
    var children: [any Coordinating]
    
    func body(content: Content) -> some View {
        applyNavigationDestinations(to: content, from: children)
    }

    @ViewBuilder
    private func applyNavigationDestinations(to content: some View, from children: [any Coordinating]) -> some View {
        if let firstChild = children.first {
            AnyView(applyNavigationDestination(for: firstChild, to: content))
                .modifier(ChildDestinationsViewModifier(children: Array(children.dropFirst())))
        } else {
            content
        }
    }
    
    private func applyNavigationDestination<C: Coordinating>(for child: C, to content: some View) -> some View {
        content.navigationDestination(for: C.Route.self) { route in
            route
        }
    }
}
