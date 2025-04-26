//
//  CoordinatorRoutesModifier.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 26.04.25.
//

import SwiftUI

/// A view modifier that handles both navigation stack routes and modal presentations
/// using a coordinator that conforms to `StackCoordinating` and `ModalCoordinating`.
///
/// This modifier sets up modal sheets, full-screen covers, and navigation destinations
/// based on the state managed by the provided coordinator.
struct CoordinatorRoutesModifier<C: StackCoordinating & ModalCoordinating>: ViewModifier {
    /// The coordinator responsible for managing stack and modal navigation.
    @ObservedObject var coordinator: C
    
    func body(content: Content) -> some View {
        content
            .modalRoutes(for: coordinator)
            .navigationDestination(for: C.Route.self) { $0 }
    }
}
