//
//  NewFlowCoordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI
import Coordinator

class NewFlowCoordinator: StackCoordinating, DeepLinkHandling {
    var initialRoute: NewScreen { NewScreen.newFlowRoot(coordinator: self) }
    var path = NavigationPath()
    weak var root: (any RootStackCoordinating)?
    
    init() {
        print("init newflowCoord")
    }
    
    deinit {
        print("deinit NewFlow Coord")
    }
    
    static nonisolated func == (lhs: NewFlowCoordinator, rhs: NewFlowCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    func handleDeepLink(_ deepLink: Coordinator.DeepLink) throws {
        print("NewFlowCoordinator - remaining: \(deepLink.remainingRoutes)")
        
        guard let firstRoute = deepLink.remainingRoutes.first else { return }
        
        switch firstRoute {
        case "view1":
            push(NewScreen.view1(coordinator: self))
        case "view2":
            push(NewScreen.view2)
            return
        case "newFlowRoot":
            popToRoot()
        default:
            print("Unknown route")
            return
        }
        
        deepLink.remainingRoutes.removeFirst()
        try? handleDeepLink(deepLink)
    }
}

enum NewScreen: Routable {
	case view1(coordinator: NewFlowCoordinator)
	case view2
	case newFlowRoot(coordinator: NewFlowCoordinator)

    var id: String {
        switch self {
        case .view1(let coordinator):
            "view1_\(coordinator.id)"
        case .view2:
            "view2"
        case .newFlowRoot(let coordinator):
            "view1_\(coordinator.id)"
        }
    }
    
	var body: some View {
		switch self {
        case .view1(let coordinator):
			NewFlowView1(coordinator: coordinator)
        case .view2:
			Text("NewFlow2")
        case .newFlowRoot(let coordinator):
            NewFlowRootView(coordinator: coordinator)
		}
	}
}
