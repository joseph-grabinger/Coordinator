//
//  FullScreenView.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 20.04.25.
//

import SwiftUI

struct FullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Hello From fullScreen")
            Button("Close") {
                dismiss()
            }
        }
    }
}

#Preview {
    FullScreenView()
}
