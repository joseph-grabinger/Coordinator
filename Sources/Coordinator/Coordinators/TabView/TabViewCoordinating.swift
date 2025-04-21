//
//  TabViewCoordinating.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

@MainActor
public protocol TabViewCoordinating: ObservableObject {
    associatedtype Route: TabRoutable
    
    var selectedTab: Route { get set }
    
    var tabs: [Route] { get }
}
