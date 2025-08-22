//
//  SettingsView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var navManager = NavManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Hello from Settings")
                .accessibilityLabel("Settings view placeholder")
                .accessibilityAddTraits(.isHeader)
            Button("Go Back") {
                navManager.back()
            }
            .accessibilityLabel("Go Back")
            .accessibilityHint("Return to previous screen")
            .accessibilityAddTraits(.isButton)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Settings screen")
    }
}

#Preview {
    SettingsView()
}
