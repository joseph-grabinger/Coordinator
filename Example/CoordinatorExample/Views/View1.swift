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
                coordinator.push(route: Screen.view2(coordinator: coordinator))
            }
            Button("Sheet") {
                coordinator.present(Screen.sheet, as: .sheet)
            }
            Button("SheetFlow") {
                coordinator.present(Screen.sheetFlow, as: .sheet)
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
                coordinator.push(route: NewScreen.view2)
            }.disabled(true)
            Button("Pop") {
                coordinator.pop()
            }
            Button("Pop to initial Route") {
                coordinator.popToInitialRoute()
			}
        }
        .navigationTitle("View 1")
    }
}
