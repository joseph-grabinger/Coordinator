//
//  ModalRoutesModifier.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 26.04.25.
//

import SwiftUI

/// A view modifier that handles modal presentations (sheets and full-screen covers)
/// using a `ModalCoordinating` object for state management.
///
/// This modifier observes a coordinator that manages modal routes (sheets and full-screen covers)
/// and presents the appropriate view when the corresponding state is set.
struct ModalRoutesModifier<C: ModalCoordinating>: ViewModifier {
    /// The coordinator responsible for managing modal presentations.
    @ObservedObject var coordinator: C

    /// The closure to execute when dismissing the sheet.
    let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.sheet, onDismiss: onDismiss) { $0 }
        #if !os(macOS)
            .fullScreenCover(item: $coordinator.fullScreenCover, onDismiss: onDismiss) { $0 }
        #endif
    }
}
