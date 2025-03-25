//
//  NewFlowCoordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

class NewFlowCoordinator: Coordinating {
    lazy var initialRoute = NewScreen.newFlowRoot(coordintor: self)
    var path = NavigationPath()
    var root: (any Coordinating)?
    
    static nonisolated func == (lhs: NewFlowCoordinator, rhs: NewFlowCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    init() {
        print("init newflowCoord")
    }
    
    deinit {
        print("deinit NewFlow Coord")
    }
}

enum NewScreen: Routable {
	nonisolated var id: UUID { UUID() }

	case view1(coordintor: NewFlowCoordinator)
	case view2
	case newFlowRoot(coordintor: NewFlowCoordinator)

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

