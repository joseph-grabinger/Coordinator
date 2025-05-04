//
//  TabView1.swift
//  CoordinatorExample
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import Coordinator

struct TabView1: View {
    @ObservedObject var homeCoordinator: HomeCoordinator
    
    var body: some View {
        CoordinatedStack(for: homeCoordinator)
            .modalRoutes(for: homeCoordinator)
    }
}

#Preview {
    TabView1(homeCoordinator: HomeCoordinator())
}
