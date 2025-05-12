//
//  View+onOpenDeepLink.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 12.05.25.
//

import SwiftUI

public extension View {

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
