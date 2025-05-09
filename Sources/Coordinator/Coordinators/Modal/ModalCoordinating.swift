//
//  ModalCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

/// A protocol defining the requirements for coordinators that manage the presentation of modals.
///
/// This protocol enables the presentation of modals like `.fullScreenCover`s & `.sheet`s.
@MainActor
public protocol ModalCoordinating: Coordinating {
    /// The type representing a modal route.
    associatedtype Route: Routable
    
    // MARK: - Properties
    
    /// The route which is currently presented as a sheet, if any.
    var sheet: Route? { get set }
    
    /// The route which is currently presented as a full screen cover, if any.
    var fullScreenCover: Route? { get set }
    
    // MARK: - Methods

    /// Presents a new `Route` with the given `ModalPresentationStyle`.
    /// - Parameters:
    ///   - route: The `Route` to present modally.
    ///   - presentationStyle: The `ModalPresentationStyle` to present the route with.
    func present(
        _ route: Route,
        as presentationStyle: ModalPresentationStyle
    )
    
    /// Dismisses the `View` currently presented using the given `PresentationStyle`.
    func dismiss(_ presentationStyle: ModalPresentationStyle)
}

// MARK: - Default Implementations

public extension ModalCoordinating {
    
    /// Default implementation of `present(_:)`, presenting a route modally with the given `ModalPresentationStyle`.
    /// - Parameters:
    ///   - route: The `Routable` instance to present.
    ///   - presentationStyle: The `ModalPresentationStyle` to present the route with.
    func present(
        _ route: Route,
        as presentationStyle: ModalPresentationStyle
    ) {
        switch presentationStyle {
        case .sheet:
            guard sheet == nil else {
                print("A sheet is already presented on \(self), cannot present route as sheet")
                return
            }
            sheet = route
        case .fullScreenCover:
            guard fullScreenCover == nil else {
                print("A fullScreenCover is already presented on \(self), cannot present route as fullScreenCover")
                return
            }
            fullScreenCover = route
        }
    }
    
    /// Default implementation of `dismiss(_:)`, dismissing the current route with the given `ModalPresentationStyle`.
    /// - Parameter presentationStyle: The `View` with the `ModalPresentationStyle` to dismiss.
    func dismiss(_ presentationStyle: ModalPresentationStyle) {
        switch presentationStyle {
        case .sheet:
            sheet = nil
        case .fullScreenCover:
            fullScreenCover = nil
        }
    }
}
