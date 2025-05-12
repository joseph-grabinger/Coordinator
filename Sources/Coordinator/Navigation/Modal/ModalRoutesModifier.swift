//
//  ModalRoutesModifier.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 26.04.25.
//

import SwiftUI

/// A view modifier that enables modal presentations via a `ModalCoordinating` object.
///
/// Applies `.sheet` and `.fullScreenCover` modifiers based on the coordinator's state.
struct ModalRoutesModifier<C: ModalCoordinating>: ViewModifier {

    /// The coordinator that manages modal presentation state.
    @ObservedObject var coordinator: C

    /// A closure to be executed when the modal is dismissed.
    let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.sheet, onDismiss: onDismiss) { $0.view }
            .fullScreenCover(item: $coordinator.fullScreenCover, onDismiss: onDismiss) { $0.view }
    }
}
