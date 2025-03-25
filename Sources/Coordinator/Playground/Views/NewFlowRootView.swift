//
//  NewFlowRootView.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

struct NewFlowRootView: View {
//    @EnvironmentObject private var coordinator: HomeCoordinator

	@EnvironmentObject private var rootCoordinator: RootCoordinator<Screen>

    var body: some View {
        List {
            Text("Hello from new flow root")
            
            Button("Push") {
				rootCoordinator.children[1].push(NewScreen.view1)
            }
            Button("Pop") {
				rootCoordinator.children[1].pop()
            }
        }
        .navigationTitle("NewFlow Root")
    }
}
