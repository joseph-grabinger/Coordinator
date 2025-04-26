//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI
import Coordinator

class HomeCoordinator: StackCoordinating, ModalCoordinating {
    lazy var initialRoute = Screen.view1(coordinator: self)
    var path = NavigationPath()
    var root: (any StackCoordinating)?
    @Published var sheet: Screen?
    @Published var fullScreenCover: Screen?
    
    static nonisolated func == (lhs: HomeCoordinator, rhs: HomeCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}

enum Screen: Routable {
	nonisolated var id: UUID { UUID() }

    case view1(coordinator: HomeCoordinator)
	case view2(coordinator: HomeCoordinator)
    case sheet
    case cover
    case sheetFlow

	var body: some View {
		switch self {
		case .view1(let coordinator):
            View1(coordinator: coordinator)
        case .view2(let coordinator):
            View2(coordinator: coordinator)
        case .sheet:
            Text("Sheet")
        case .cover:
            FullScreenView()
        case .sheetFlow:
            CoordinatedStack(for: NewFlowCoordinator())
		}
	}
}
