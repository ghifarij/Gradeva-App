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
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isSignedIn {
                // Signed-in  --> show HomeView
                HomeView()
            } else {
                // Not signed in --> show SignInView
                SignInView()
            }
            
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    MainContentView()
}
