//
//  TabCoordinator.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import Coordinator

class TabCoordinator: TabViewCoordinating {
    @Published var selectedTab = Tab.tab1
    
    lazy var tabs: [Tab] = [ .tab1, .tab2(coordinator: self) ]
    
    static nonisolated func == (lhs: TabCoordinator, rhs: TabCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}

enum Tab: TabRoutable {
    
    case tab1
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
        case .tab1:
            TabView1()
        case .tab2(let coordinator):
            NavigationStack {
                Button("Change Tab") {
                    coordinator.select(.tab1)
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
