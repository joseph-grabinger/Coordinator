//
//  TabView1.swift
//  CoordinatorExample
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI
import Coordinator

struct TabView1: View {
    @StateObject var c = HomeCoordinator()
    
    var body: some View {
        CoordinatedStack(for: c)
            .modalRoutes(for: c)
    }
}

#Preview {
    TabView1()
}
