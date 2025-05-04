//
//  NewFlowCoordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI
import Coordinator

class NewFlowCoordinator: StackCoordinating {
    var initialRoute: NewScreen { NewScreen.newFlowRoot(coordintor: self) }
    var path = NavigationPath()
    weak var root: (any RootStackCoordinating)?
    var sheet: NewScreen?
    var fullScreenCover: NewScreen?
    
    init() {
        print("init newflowCoord")
    }
    
    deinit {
        print("deinit NewFlow Coord")
    }
    
    static nonisolated func == (lhs: NewFlowCoordinator, rhs: NewFlowCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}

enum NewScreen: Routable {
	case view1(coordintor: NewFlowCoordinator)
	case view2
	case newFlowRoot(coordintor: NewFlowCoordinator)

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
