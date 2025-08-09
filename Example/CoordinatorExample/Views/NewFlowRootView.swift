//
//  NewFlowRootView.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

struct NewFlowRootView: View {
    @ObservedObject var coordinator: NewFlowCoordinator
    
    var body: some View {
        List {
            Text("Hello from new flow root")
            
            Button("Push") {
                coordinator.push(route: NewScreen.view1(coordinator: coordinator))
            }
            Button("Pop") {
                coordinator.pop()
            }
            Button("Pop to initial Route") {
                coordinator.popToInitialRoute()
            }
        }
        .navigationTitle("NewFlow Root")
    }
}
