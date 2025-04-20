//
//  View1 2.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 21.02.25.
//


import SwiftUI

struct View2: View {
    @ObservedObject var coordinator: HomeCoordinator

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
                coordinator.pushCoordinator(NewFlowCoordinator())
            }
            Button("Full Screen Cover") {
                coordinator.present(Screen.cover, as: .fullScreenCover)
            }
        }
        .navigationTitle("View 2")
        .navigationDestination(for: NewScreen.self) { $0 }
    }
}
