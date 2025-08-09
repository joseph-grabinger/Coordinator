//
//  View+Extensions.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

public extension View {
    
    /// Attaches modal presentation handling to the view using the given `ModalCoordinating` coordinator.
    ///
    /// This modifier enables presenting sheets and full-screen covers based on the coordinator's state.
    ///
    /// - Parameter coordinator: The coordinator for which to attach the modal route.
    /// - Returns: A view with modal routes attached.
    func modalRoutes<C: ModalCoordinating>(for coordinator: C, onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(ModalRoutesModifier(coordinator: coordinator, onDismiss: onDismiss))
    }
    
    /// Attaches both modal and navigation stack presentation handling to the view
    /// using the given coordinator that conforms to `StackCoordinating` and `ModalCoordinating`.
    ///
    /// This modifier enables presenting sheets, full-screen covers, and navigation destinations
    /// based on the coordinator's state.
    ///
    /// - Parameter coordinator: The coordinator for which to attach the routes.
    /// - Returns: A view with both modal and coordinator navigation routes attached.
    func coordinatorRoutes<C: StackCoordinating & ModalCoordinating>(for coordinator: C) -> some View {
        self.modifier(CoordinatorRoutesModifier(coordinator: coordinator))
    }
    
    /// Registers a handler to invoke in response to a `DeepLink` that your app receives.
    ///
    /// For more information about linking into your app, see
    /// [Allowing apps and websites to link to your content](com.apple.documentation/documentation/Xcode/allowing-apps-and-websites-to-link-to-your-content).
    ///
    /// - Parameter action: A closure that SwiftUI calls when your app receives a Universal Link or a custom `URL`. The closure takes the `DeepLink` as an input parameter.
    /// - Returns: A view that handles incoming `DeepLink`s.
    func onOpenDeepLink(perform action: @escaping (DeepLink) -> ()) -> some View {
        self.onOpenURL { url in
            action(DeepLink(from: url))
        }
    }
}
