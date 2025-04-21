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
    @StateObject private var coordinator = HomeCoordinator()
    
    // MARK: - Body
    
    var body: some View {
        RootCoordinatorView(for: coordinator)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
