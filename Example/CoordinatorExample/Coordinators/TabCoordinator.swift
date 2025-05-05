//
//  TabCoordinator.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import Coordinator

class TabCoordinator: TabViewCoordinating, DeepLinkHandling, DeepLinkValidityChecking {
    
    // - MARK: Internal Properties
    
    @Published var selectedTab: Tab
    
    lazy var tabs: [Tab] = [ .tab1(homeCoordinator: homeCoordinator), .tab2(coordinator: self) ]
    
    let homeCoordinator: HomeCoordinator
    
    // - MARK: Initialization

    init() {
        self.homeCoordinator = HomeCoordinator()
        self.selectedTab = .tab1(homeCoordinator: homeCoordinator)
    }
    
    // - MARK: Static Methods

    static nonisolated func == (lhs: TabCoordinator, rhs: TabCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    static func canHandleDeepLink(_ deepLink: DeepLink) -> Bool {
        guard let firstRoute = deepLink.remainingRoutes.first else {
            return false
        }
        
        if firstRoute == "tab1" {
            deepLink.remainingRoutes.removeFirst()
            return HomeCoordinator.canHandleDeepLink(deepLink)
        } else {
            return firstRoute == "tab2" && deepLink.remainingRoutes.count == 1
        }
    }
    
    // - MARK: Internal Methods
    
    func handleDeepLink(_ deepLink: DeepLink) throws {
        print("TabCoordinator - remaining: \(deepLink.remainingRoutes)")
        
        guard let firstRoute = deepLink.remainingRoutes.first else { return }
        
        switch firstRoute {
        case "tab1":
            selectedTab = tabs.first!
            deepLink.remainingRoutes.removeFirst()
            try homeCoordinator.handleDeepLink(deepLink)
        case "tab2":
            selectedTab = tabs.last!
        default:
            throw DeepLinkingError.invalidDeepLink(firstRoute)
        }
    }
    
}

enum Tab: TabRoutable {
    case tab1(homeCoordinator: HomeCoordinator)
    case tab2(coordinator: TabCoordinator)
    
    var id: String {
        switch self {
        case .tab1:
            "tab1"
        case .tab2(let coordinator):
            "tab2\(coordinator.id)"
        }
    }
    
    var body: some View {
        switch self {
        case .tab1(let homeCoordinator):
            TabView1(homeCoordinator: homeCoordinator)
        case .tab2(let coordinator):
            NavigationStack {
                Button("Change Tab") {
                    coordinator.select(coordinator.tabs.first!)
                }
                .navigationTitle("Test Tab")
            }
        }
    }
    
    var label: Label<Text, Image> {
        switch self {
        case .tab1:
            Label("Home", systemImage: "circle")
        case .tab2:
            Label("Test", systemImage: "star")
        }
    }
}
