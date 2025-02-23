//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import SwiftUI
import Combine

@MainActor
open class Coordinator: ObservableObject, Navigating {
    
    public let initialRoute: any Routable
    
    @Published public var path: NavPath
    
    public var cancelBag = Set<AnyCancellable>()
    
    weak var parent: Coordinator?
    
    init(initialRoute: any Routable, pushInitialRoute: Bool = true) {
        self.initialRoute = initialRoute
        self.path = NavPath(pushInitialRoute ? [AnyRoutable(initialRoute)] : [])
    }
}
