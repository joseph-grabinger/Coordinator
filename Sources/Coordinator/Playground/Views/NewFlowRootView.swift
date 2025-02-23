//
//  NewFlowRootView.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

struct NewFlowRootView: View {
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    var body: some View {
        List {
            Text("Hello from new flow root")
            
            Button("Push") {
                coordinator.flowCoordinator.push(NewFlowScreen.view1)
            }
            Button("Pop") {
                coordinator.flowCoordinator.pop()
            }
        }
        .navigationTitle("NewFlow Root")
    }
}
