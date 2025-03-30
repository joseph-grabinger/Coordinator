//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

class HomeCoordinator: Coordinating {
    lazy var initialRoute = Screen.view1(coordintor: self)
    var path = NavigationPath()
    var root: (any Coordinating)?
    
    static nonisolated func == (lhs: HomeCoordinator, rhs: HomeCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}

enum Screen: Routable {
	nonisolated var id: UUID { UUID() }

    case view1(coordintor: HomeCoordinator)
	case view2(coordintor: HomeCoordinator)

	var body: some View {
		switch self {
		case .view1(let coordinator):
            View1(coordinator: coordinator)
        case .view2(let coordinator):
            View2(coordinator: coordinator)
		}
	}
}
