//
//  ModalCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import OSLog

/// A protocol for coordinators that manage modal presentations such as sheets and full-screen covers.
///
/// Conforming types are responsible for updating modal state to trigger presentation and dismissal.
public protocol ModalCoordinating: Coordinating {

    /// The type representing a modal route, which must conform to `Routable`.
    associatedtype Route: Routable

    // MARK: - Properties

    /// The currently presented sheet route, or `nil` if no sheet is presented.
    var sheet: Route? { get set }

    /// The currently presented full-screen cover route, or `nil` if none is presented.
    var fullScreenCover: Route? { get set }
}

// MARK: - Convenience Methods

public extension ModalCoordinating {

    /// Presents a route modally with the specified style, if not already presented.
    ///
    /// Prevents multiple simultaneous presentations for the same style.
    ///
    /// - Parameters:
    ///   - route: The route instance to present.
    ///   - presentationStyle: The presentation style to use.
    func present(_ route: Route, as presentationStyle: ModalPresentationStyle) {
        switch presentationStyle {
        case .sheet:
            guard sheet == nil else {
                Logger.navKit.warning("Cannot present \"\(route)\" as sheet: \"\(self)\" is already presenting \"\(self.sheet!)\".")
                return
            }
            sheet = route
        case .fullScreenCover:
            guard fullScreenCover == nil else {
                Logger.navKit.warning("Cannot present \"\(route)\" as fullScreenCover: \"\(self)\" is already presenting \"\(self.fullScreenCover!)\".")
                return
            }
            fullScreenCover = route
        }
    }

    /// Dismisses the currently presented modal view with the specified presentation style.
    ///
    /// - Parameter presentationStyle: The presentation style to dismiss.
    func dismiss(_ presentationStyle: ModalPresentationStyle) {
        switch presentationStyle {
        case .sheet:
            sheet = nil
        case .fullScreenCover:
            fullScreenCover = nil
        }
    }
}
