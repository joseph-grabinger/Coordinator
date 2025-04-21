//
//  ContentView.swift
//  CoordinatorExample
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import Coordinator

struct ContentView: View {
    
    /// The custom coordinator instance.
    @StateObject private var coordinator = TabCoordinator()
//    @StateObject private var coordinator = HomeCoordinator()
    
    // MARK: - Body
    
    var body: some View {
        CoordinatedTabView(for: coordinator)
//        CoordinatedStack(for: coordinator)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
