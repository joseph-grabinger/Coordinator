//
//  PresentationMode.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 20.04.25.
//

/// An enumeration that defines the available presentation styles for modals.
public enum ModalPresentationStyle {
    
    /// Presents a `View` modally as a sheet over the current context.
    case sheet
    
    /// Presents a full screen `View`, which covers as much of the screen as possible.
    case fullScreenCover
}
