//
//  ContentView.swift
//  CoordinatorExample
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import Coordinator

struct ContentView: View {
    
    // MARK: - Private Properties

    /// The custom coordinator instance.
    @StateObject private var coordinator = TabCoordinator()
    
    /// The error which occured during the handling of a `DeepLink`, if any.
    @State private var deepLinkingError: Error?
    
    // MARK: - Body
    
    var body: some View {
        CoordinatedTabView(for: coordinator)
            .onOpenDeepLink { deepLink in
                do {
                    try coordinator.handleDeepLink(deepLink)
                } catch {
                    deepLinkingError = error
                }
            }
            .overlay {
                if let deepLinkingError {
                    errorView(for: deepLinkingError)
                }
            }
    }
    
    // MARK: - Private Methods
    
    /// Returns the error view for a given `Error`.
    /// - Parameter error: The error which to display.
    /// - Returns: The populated error view.
    private func errorView(for error: Error) -> some View {
        VStack {
            Label(error.localizedDescription, systemImage: "exclamationmark.triangle")
            Button("Okay") {
                self.deepLinkingError = nil
            }
        }
        .padding()
        .background(.thickMaterial,
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
