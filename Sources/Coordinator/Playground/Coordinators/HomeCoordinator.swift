//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

class HomeCoordinator: Coordinator {
    lazy var flowCoordinator = NewFlowCoordinator()
    
//    var initialRoute: any Routable = Screen.view1
    
    
//    @Published var path = NavPath()
    
    init() {
        super.init(initialRoute: Screen.view1, pushInitialRoute: false)
    }
}

enum Screen: Routable {
    case view1
    case view2
    
    @ViewBuilder
    func buildView() -> some View {
        switch self {
        case .view1:
            View1()
        case .view2:
            View2()
        }
    }
}
