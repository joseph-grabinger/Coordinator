//
//  View1 2.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//


import SwiftUI

struct View2: View {
    
    @EnvironmentObject private var coordinator: HomeCoordinator
        
    var body: some View {
        List {
            Button("Push") {}
                .disabled(true)
            Button("Pop") {
                coordinator.pop()
            }
            Button("Pop to Root") {
                coordinator.popToRoot()
            }
            
            Button("New Flow") {
                coordinator.pushCoordinator(coordinator.flowCoordinator)
            }
        }
        .navigationTitle("View 2")
    }
}

#Preview {
    View2()
}
