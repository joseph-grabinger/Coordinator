//
//  DeepLinkingError.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 27.04.25.
//

/// An enumeration of errors that may occur during the processing of deep links.
public enum DeepLinkingError: Error {
    
    /// Indicates that the deep link contains an invalid host.
    /// - Parameter: A `String` value describing the invalid host.
    case invalidHostError(String)
    
    /// Indicates that the deep link contains an invalid path component.
    /// - Parameter: A `String` value describing the invalid path component.
    case invalidPathComponentError(String)
    
    case invalidDeepLink(String)
}
