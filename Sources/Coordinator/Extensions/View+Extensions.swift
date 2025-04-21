//
//  View+Extensions.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import SwiftUI

public extension View {
    
    func modalRoutes<C: ModalCoordinating>(for coordinator: Binding<C>) -> some View {
        self
            .sheet(
                item: coordinator.sheet,
                onDismiss: { coordinator.wrappedValue.dismiss(.sheet) }
            ) { $0 }
            .fullScreenCover(
                item: coordinator.fullScreenCover,
                onDismiss: { coordinator.wrappedValue.dismiss(.fullScreenCover) }
            ) { $0 }
    }
}
