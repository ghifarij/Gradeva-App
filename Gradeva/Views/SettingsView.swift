//
//  SettingsView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var navManager: NavManager
    
    var body: some View {
        Text("Hello from Settings")
        Button("Go Back") {
            navManager.back()
        }
    }
}

#Preview {
    SettingsView()
}
