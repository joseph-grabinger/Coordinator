//
//  View1 2.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//


import SwiftUI

struct View2: View {
    
	@EnvironmentObject private var rootCoordinator: RootCoordinator<Screen>

    var body: some View {
        List {
            Button("Push") {}
                .disabled(true)
            Button("Pop") {
				rootCoordinator.children[0].pop()
            }
            Button("Pop to Root") {
				rootCoordinator.children[0].popToRoot()
            }

            Button("New Flow") {
				rootCoordinator.children[0].pushCoordinator(NewFlowCoordinator())
//                coordinator.pushCoordinator(coordinator.flowCoordinator)
            }
        }
        .navigationTitle("View 2")
    }
}

#Preview {
    View2()
}
