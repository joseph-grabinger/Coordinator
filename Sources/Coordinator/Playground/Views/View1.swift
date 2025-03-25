//
//  View1.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

struct View1: View {
    
	@EnvironmentObject private var rootCoordinator: RootCoordinator<Screen>

    var body: some View {
        List {
            Button("Push") {
				rootCoordinator.children[0].push(Screen.view2)
//				coordinator.push(HomeCoordinator.Screen.view2)
            }
            Button("Pop") {
                rootCoordinator.children[0].pop()
            }
        }
        .navigationTitle("View 1")
    }
}

struct NewFlowView1: View {
    
	@EnvironmentObject private var rootCoordinator: RootCoordinator<Screen>

    var body: some View {
        List {
            Button("Push") {
				rootCoordinator.children[1].push(NewScreen.view2)
            }.disabled(true)
            Button("Pop") {
				rootCoordinator.children[1].pop()
            }
            Button("Pop to Root") {
				rootCoordinator.children[1].popToRoot()
			}
        }
        .navigationTitle("View 1")
    }
}

//#Preview {
//    View1()
//}
