//
//  View1.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

struct View1: View {
    
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    var body: some View {
        List {
            Button("Push") {
                coordinator.push(Screen.view2)
            }
            Button("Pop") {
                coordinator.pop()
            }
        }
        .navigationTitle("View 1")
    }
}

struct NewFlowView1: View {
    
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    var body: some View {
        List {
            Button("Push") {
                coordinator.flowCoordinator.push(Screen.view2)
            }.disabled(true)
            Button("Pop") {
                coordinator.flowCoordinator.pop()
            }
            Button("Pop to Root") {
                coordinator.flowCoordinator.popToRoot()
            }
        }
        .navigationTitle("View 1")
    }
}

#Preview {
    View1()
}
