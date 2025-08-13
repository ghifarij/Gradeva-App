//
//  MainContentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 12/08/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MainContentView: View {
    @StateObject private var viewModel = AuthManager()
    @StateObject private var navManager = NavManager()
    
    var body: some View {
        NavigationStack(path: $navManager.paths) {
            if viewModel.isSignedIn {
                // Signed-in  --> show HomeView
                HomeView()
                    .navigationDestination(for: NavPath.self) { path in
                        switch path {
                        case .home:
                            HomeView()
                        case .settings:
                            SettingsView()
                        }
                    }
            } else {
                // Not signed in --> show SignInView
                SignInView()
            }
            
        }
        .environmentObject(viewModel)
        .environmentObject(navManager)
    }
}

#Preview {
    MainContentView()
}
