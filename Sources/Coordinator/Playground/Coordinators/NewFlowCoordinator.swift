//
//  NewFlowCoordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

class NewFlowCoordinator: Coordinator {
//    var initialRoute: any Routable = NewFlowScreen.newFlowRoot
    
//    @MainActor func buildRootView() -> some View {
//        return
//    }
    
    init() {
        print("init newflowCoord")
        super.init(initialRoute: NewFlowScreen.newFlowRoot)
    }
    
    deinit {
        print("deinit NewFlow Coord")
    }
}

enum NewFlowScreen: Routable {
    case view1
    case view2
    case newFlowRoot

    @ViewBuilder
    func buildView() -> some View {
        switch self {
        case .view1:
            NewFlowView1()
        case .view2:
            Text("NewFlow2")
            /*NewFlowView2()*/
        case .newFlowRoot:
            NewFlowRootView()
        }
    }
}
