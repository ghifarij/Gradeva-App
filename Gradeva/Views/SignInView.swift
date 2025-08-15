//
//  ContentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject private var auth: AuthManager
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
            
            
            ZStack {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: auth.handleSignInWithAppleRequest,
                    onCompletion: auth.handleSignInWithAppleCompletion
                )
                .signInWithAppleButtonStyle(signInColor)
                .frame(width: 280, height: 45)
                .cornerRadius(8)
                .disabled(auth.isAuthLoading)
                .opacity(auth.isAuthLoading ? 0.5 : 1) // dim when loading
                
                if auth.isAuthLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    SignInView()
}
