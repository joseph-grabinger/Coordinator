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
    
    // MARK: - Body
    
    var body: some View {
        CoordinatedTabView(for: coordinator)
            .onOpenDeepLink { deepLink in
                try? coordinator.handleDeepLink(deepLink)
            }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
