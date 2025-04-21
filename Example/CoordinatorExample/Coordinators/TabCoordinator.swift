//
//  TabCoordinator.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

class TabCoordinator: TabViewCoordinating {
    @Published var selectedTab = Tab.tab1
    
    let tabs: [Tab] = [ .tab1, .tab2 ]
}

enum Tab: TabRoutable {
    nonisolated var id: UUID { UUID() }

    case tab1
    case tab2
    
    var body: some View {
        switch self {
        case .tab1:
            HomeTab()
//            CoordinatedStack(for: HomeCoordinator())
//                .navigationTitle("HomeView")
        case .tab2:
            NavigationStack {
                Text("TestView")
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
