//
//  DeepLinkHandling.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 27.04.25.
//

import Foundation

/// A protocol that defines the requirements for handling deep links.
public protocol DeepLinkHandling {
    
    var deepLinks: [String: () -> Void] { get }
    
    /// Handles the given deep link.
    /// - Parameter deepLink: The deep link to process.
    func handleDeepLink(_ deepLink: DeepLink) throws
}

// MARK: - Default Implementation

public extension DeepLinkHandling {
    func handleDeepLink(_ deepLink: DeepLink) throws {
        guard !deepLink.remainingRoutes.isEmpty else { return }
        
        guard let relevantRemainingRoutes = firstRelevantRemainingRoutes(from: deepLink),
              let firstRelevantRoute = relevantRemainingRoutes.first,
              let deepLinkAction = deepLinks[firstRelevantRoute]
        else {
            throw DeepLinkingError.invalidDeepLink("Invalid DeepLink for \(self)")
        }
        
        print("navigating on \(self) to \(firstRelevantRoute)")
        deepLinkAction()
        deepLink.remainingRoutes = Array(relevantRemainingRoutes.dropFirst())
        try? handleDeepLink(deepLink)
    }
    
    private func lastRelevantRemainingRoutes(from deepLink: DeepLink) -> [String]? {
        print("called with: \(deepLink.remainingRoutes)")
        let reversedRoutes = deepLink.remainingRoutes.reversed()
        
        var linkIndex: Int? = nil
        for (index, link) in reversedRoutes.enumerated() {
            if let _ = deepLinks[link] {
                linkIndex = index
                break
            }
        }
        
        guard let linkIndex else { return nil }
        
        print("index is :\(linkIndex)")
        let relevantRoutes = (reversedRoutes.prefix(linkIndex+1)).reversed()
        print("relevant Remainder of \(self) is \(relevantRoutes)")
        return Array(relevantRoutes)
    }
    
    private func firstRelevantRemainingRoutes(from deepLink: DeepLink) -> [String]? {
        print("called with: \(deepLink.remainingRoutes)")
        
        guard let linkIndex = deepLink.remainingRoutes.firstIndex(where: { deepLinks[$0] != nil }) else {
            return nil
        }
        
        print("index is: \(linkIndex)")
        let relevantRoutes = deepLink.remainingRoutes.suffix(from: linkIndex)
        print("relevant remainder of \(self) is \(relevantRoutes)")
        return Array(relevantRoutes)
    }
}
