//
//  HomeTab.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

struct HomeTab: View {
    @StateObject private var coordinator = HomeCoordinator()
    
    var body: some View {
        CoordinatedStack(for: coordinator)
    }
}

#Preview {
    HomeTab()
}
