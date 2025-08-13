//
//  ContentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private var signInColor: SignInWithAppleButton.Style {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        VStack {
            Text("Sign In to Gradeva")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            
            SignInWithAppleButton(
                .signIn,
                onRequest: viewModel.handleSignInWithAppleRequest,
                onCompletion: viewModel.handleSignInWithAppleCompletion
            )
            .signInWithAppleButtonStyle(signInColor)
            .frame(width: 280, height: 45)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    SignInView()
}
