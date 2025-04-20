//
//  CoordinatorPlayground.swift
//  NavigationCoordinator
//
//  Created by Joseph Grabinger on 20.02.25.
//

import SwiftUI

/// A demo `View` showcasing the usage of the `NavigationCoordinator` package.
struct CoordinatorPlayground: View {
    
    /// The custom coordinator instance.
    @StateObject private var coordinator = HomeCoordinator()
    
    // MARK: - Body
    
    var body: some View {
        CoordinatedStack(for: coordinator)
    }
}

// MARK: - Preview

#Preview {
    CoordinatorPlayground()
}
