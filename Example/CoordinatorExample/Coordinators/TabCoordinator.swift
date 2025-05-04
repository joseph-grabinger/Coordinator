//
//  TabCoordinator.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import Coordinator

class TabCoordinator: TabViewCoordinating, StackChildContaining {
    
    @Published var selectedTab: Tab
    
    lazy var tabs: [Tab] = [ .tab1(homeCoordinator: homeCoordinator), .tab2(coordinator: self) ]
    
    var homeCoordinator: HomeCoordinator
    
    init() {
        self.homeCoordinator = HomeCoordinator()
        self.selectedTab = .tab1(homeCoordinator: homeCoordinator)
    }
    
    static nonisolated func == (lhs: TabCoordinator, rhs: TabCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    func coordinator(for tab: Tab) -> (any StackCoordinating)? {
        selectedTab == tabs.first ? homeCoordinator : nil
    }
    
}

enum Tab: TabRoutable {
    
    case tab1(homeCoordinator: HomeCoordinator)
    case tab2(coordinator: TabCoordinator)
    
    var id: String {
        switch self {
        case .tab1:
            "tab1"
        case .tab2:
            "tab2"
        }
    }
    
    var body: some View {
        switch self {
        case .tab1(let homeCoordinator):
            TabView1(homeCoordinator: homeCoordinator)
        case .tab2(let coordinator):
            NavigationStack {
                Button("Change Tab") {
                    coordinator.select(Tab.tab1(homeCoordinator: coordinator.homeCoordinator))
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
