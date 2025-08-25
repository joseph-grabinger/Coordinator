//
//  ModalCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import OSLog

/// A protocol defining the requirements for coordinators that manage the presentation of modals.
///
/// This protocol enables the presentation of modals like `.fullScreenCover`s & `.sheet`s.
public protocol ModalCoordinating: Coordinating {
    
    /// The type representing a modal route.
    associatedtype Route: Routable
    
    // MARK: - Properties
    
    /// The route which is currently presented as a sheet, if any.
    var sheet: Route? { get set }
    
#if !os(macOS)
    /// The route which is currently presented as a full screen cover, if any.
    var fullScreenCover: Route? { get set }
#endif
}

// MARK: - Navigation Methods

public extension ModalCoordinating {
    
    /// Presents a new `Route` with the given `ModalPresentationStyle`.
    /// - Parameters:
    ///   - route: The `Route` to present modally.
    ///   - presentationStyle: The `ModalPresentationStyle` to present the route with.
    func present(
        _ route: Route,
        as presentationStyle: ModalPresentationStyle
    ) {
        switch presentationStyle {
        case .sheet:
            guard sheet == nil else {
                Logger.coordinator.warning("Cannot present \"\(route)\" as sheet: \"\(self)\" is already presenting \"\(self.sheet!)\".")
                return
            }
            sheet = route
#if !os(macOS)
        case .fullScreenCover:
            guard fullScreenCover == nil else {
                Logger.coordinator.warning("Cannot present \"\(route)\" as fullScreenCover: \"\(self)\" is already presenting \"\(self.fullScreenCover!)\".")
                return
            }
            fullScreenCover = route
#endif
        }
    }
    
    /// Dismisses the currently presented modal `Route` with the specified `ModalPresentationStyle`.
    /// - Parameter presentationStyle: The presentation style to dismiss
    func dismiss(_ presentationStyle: ModalPresentationStyle) {
        switch presentationStyle {
        case .sheet:
            sheet = nil
#if !os(macOS)
        case .fullScreenCover:
            fullScreenCover = nil
#endif
        }
    }
}
