//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

class HomeCoordinator: Coordinator<Screen> {

//    lazy var flowCoordinator = NewFlowCoordinator()
    
    init() {
		super.init(initialRoute: Screen.view1, pushInitialRoute: false)
    }


}

enum Screen: Routable {
	nonisolated var id: UUID { UUID() }

	case view1
	case view2

	var body: some View {
		switch self {
		case .view1:
			View1()
		case .view2:
			View2()
		}
	}
}

