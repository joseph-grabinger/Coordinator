//
//  View+modalRoutes.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 12.05.25.
//

import SwiftUI

public extension View {

    /// Attaches modal presentation behavior to the view using a `ModalCoordinating` coordinator.
    ///
    /// Enables the view to present sheets and full-screen covers based on the coordinator’s state.
    ///
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for modal presentation.
    ///   - onDismiss: An optional closure called when a modal is dismissed.
    /// - Returns: A view modified to support modal presentations.
    func modalRoutes<C: ModalCoordinating>(for coordinator: C, onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(ModalRoutesModifier(coordinator: coordinator, onDismiss: onDismiss))
    }
}
