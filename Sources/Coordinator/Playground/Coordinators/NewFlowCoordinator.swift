//
//  NewFlowCoordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

class NewFlowCoordinator: Coordinator<NewScreen> {

    init() {
        print("init newflowCoord")
		super.init(initialRoute: NewScreen.newFlowRoot)
    }
    
    deinit {
        print("deinit NewFlow Coord")
    }
}

enum NewScreen: Routable {
	nonisolated var id: UUID { UUID() }

	case view1
	case view2
	case newFlowRoot

	var body: some View {
		switch self {
		case .view1:
			NewFlowView1()
		case .view2:
			Text("NewFlow2")
		case .newFlowRoot:
			NewFlowRootView()
		}
	}
}

