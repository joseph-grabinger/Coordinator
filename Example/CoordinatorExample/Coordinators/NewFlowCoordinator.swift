//
//  NewFlowCoordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI
import Coordinator

class NewFlowCoordinator: StackCoordinating, DeepLinkHandling, DeepLinkValidityChecking {

    // - MARK: Internal Properties
    
    let id = "NewFlowCoordinator"

    var initialRoute: NewScreen { NewScreen.newFlowRoot(coordinator: self) }
    
    var presentedRoutes = [NewScreen]()
    
    weak var root: (any RootStackCoordinating)?
    
    // - MARK: Initialization

    init() {
        print("init NewFlowCoordinator")
    }
    
    deinit {
        print("deinit NewFlowCoordinator")
    }
    
    // - MARK: Static Methods
    
    static func canHandleDeepLink(_ deepLink: Coordinator.DeepLink) -> Bool {
        guard let firstRoute = deepLink.remainingRoutes.first else {
            return true
        }
        
        return ["view1", "view2", "newFlowRoot"].contains(firstRoute) && deepLink.remainingRoutes.count == 1
    }
    
    // - MARK: Internal Methods

    func handleDeepLink(_ deepLink: Coordinator.DeepLink) throws {
        guard let firstRoute = deepLink.remainingRoutes.first else { return }
        
        switch firstRoute {
        case "view1":
            push(route: NewScreen.view1(coordinator: self))
        case "view2":
            push(route: NewScreen.view2)
            return
        case "newFlowRoot":
            popToInitialRoute()
        default:
            throw DeepLinkingError.invalidDeepLink(firstRoute)
        }
        
        deepLink.remainingRoutes.removeFirst()
        try handleDeepLink(deepLink)
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
