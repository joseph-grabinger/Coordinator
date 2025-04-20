//
//  View1.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//

import SwiftUI

struct View1: View {
    @ObservedObject var coordinator: HomeCoordinator

    var body: some View {
        List {
            Button("Push") {
                coordinator.push(Screen.view2(coordinator: coordinator))
            }
            Button("Sheet") {
                coordinator.present(Screen.sheet, as: .modal)
            }
        }
        .navigationTitle("View 1")
    }
}

struct NewFlowView1: View {
    @ObservedObject var coordinator: NewFlowCoordinator

    var body: some View {
        List {
            Button("Push") {
                coordinator.push(NewScreen.view2)
            }.disabled(true)
            Button("Pop") {
                coordinator.pop()
            }
            Button("Pop to Root") {
                coordinator.popToRoot()
			}
        }
        .navigationTitle("View 1")
    }
}
