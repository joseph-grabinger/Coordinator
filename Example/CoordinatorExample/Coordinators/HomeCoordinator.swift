//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI
import Coordinator

class HomeCoordinator: StackCoordinating, ModalCoordinating, DeepLinkHandling, DeepLinkValidityChecking {
    
    // - MARK: Internal Properties

    var initialRoute: Screen { Screen.view1(coordinator: self) }

    var path = NavigationPath()

    weak var root: (any RootStackCoordinating)?

    @Published var sheet: Screen?

    @Published var fullScreenCover: Screen?
    
    // - MARK: Static Methods

    static nonisolated func == (lhs: HomeCoordinator, rhs: HomeCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    static func canHandleDeepLink(_ deepLink: DeepLink) -> Bool {
        guard let firstRoute = deepLink.remainingRoutes.first else {
            return true
        }
        
        switch firstRoute {
        case "view1", "view2":
            deepLink.remainingRoutes.removeFirst()
            return Self.canHandleDeepLink(deepLink)
        case "sheet", "cover", "sheetFlow":
            return deepLink.remainingRoutes.count == 1
        case "newFlowRoot":
            deepLink.remainingRoutes.removeFirst()
            return NewFlowCoordinator.canHandleDeepLink(deepLink)
        default:
            return false
        }
    }
    
    // - MARK: Internal Methods

    func handleDeepLink(_ deepLink: DeepLink) throws {
        guard let firstRoute = deepLink.remainingRoutes.first else { return }
        
        switch firstRoute {
        case "view1":
            popToRoot()
        case "view2":
            push(Screen.view2(coordinator: self))
        case "newFlowRoot":
            let newFlowCoordinator = NewFlowCoordinator()
            pushCoordinator(newFlowCoordinator)
            deepLink.remainingRoutes.removeFirst()
            try newFlowCoordinator.handleDeepLink(deepLink)
            return
        case "sheet":
            present(Screen.sheet, as: .sheet)
            return
        case "cover":
            present(Screen.cover, as: .fullScreenCover)
            return
        case "sheetFlow":
            present(Screen.sheetFlow, as: .sheet)
            return
        default:
            throw DeepLinkingError.invalidDeepLink(firstRoute)
        }
        
        deepLink.remainingRoutes.removeFirst()
        try handleDeepLink(deepLink)
    }
}

enum Screen: Routable {
    case view1(coordinator: HomeCoordinator)
	case view2(coordinator: HomeCoordinator)
    case sheet
    case cover
    case sheetFlow
    
    var id: String {
        switch self {
        case .view1(let coordinator):
            "view1_\(coordinator.id)"
        case .view2(let coordinator):
            "view2_\(coordinator.id)"
        case .sheet:
            "sheet"
        case .cover:
            "cover"
        case .sheetFlow:
            "sheetFlow"
        }
    }

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
