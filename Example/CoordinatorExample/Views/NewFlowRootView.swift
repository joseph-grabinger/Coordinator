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
                coordinator.push(NewScreen.view1(coordintor: coordinator))
            }
            Button("Pop") {
                coordinator.pop()
            }
            Button("Po to Root") {
                coordinator.popToRoot()
            }
        }
        .navigationTitle("NewFlow Root")
    }
}
