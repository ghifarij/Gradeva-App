//
//  ContentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn

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
            
            VStack(spacing: 12) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: auth.handleSignInWithAppleRequest,
                    onCompletion: auth.handleSignInWithAppleCompletion
                )
                .signInWithAppleButtonStyle(signInColor)
                .frame(width: 280, height: 45)
                .cornerRadius(8)
                .disabled(auth.isAuthLoading)
                .opacity(auth.isAuthLoading ? 0.5 : 1)
          
                Button(action: auth.handleSignInWithGoogle) {
                    HStack(spacing: 4) {
                        Image("g")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text("Sign in with Google")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .frame(width: 280, height: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    )
                }
                .disabled(auth.isAuthLoading)
                .opacity(auth.isAuthLoading ? 0.5 : 1)
            }
            
            if let error = auth.authError {
                InlineErrorView(error: error)
                    .padding(.top)
            }
            
        }
        .padding()
    }
}


#Preview {
    SignInView()
}
