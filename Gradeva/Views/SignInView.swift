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
    @ObservedObject private var auth = AuthManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    private var signInColor: SignInWithAppleButton.Style {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        VStack {
            Text("Gradeva")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("Sign In to Gradeva")
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: auth.handleSignInWithAppleRequest,
                    onCompletion: auth.handleSignInWithAppleCompletion
                )
                .signInWithAppleButtonStyle(signInColor)
                .frame(height: 44)
                .cornerRadius(8)
                .disabled(auth.isAuthLoading)
                .opacity(auth.isAuthLoading ? 0.5 : 1)
                .accessibilityLabel("Sign in with Apple")
                .accessibilityHint("Double tap to sign in using your Apple ID")
                .accessibilityAddTraits(.isButton)
                .accessibilityRemoveTraits(auth.isAuthLoading ? .isButton : [])
                .accessibilityValue(auth.isAuthLoading ? "Loading" : "")
          
                Button(action: auth.handleSignInWithGoogle) {
                    HStack(spacing: 5) {
                        Image("g")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .accessibilityHidden(true)
                        Text("Sign in with Google")
                            .font(.system(size: 17))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
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
                .accessibilityLabel("Sign in with Google")
                .accessibilityHint("Double tap to sign in using your Google account")
                .accessibilityAddTraits(.isButton)
                .accessibilityValue(auth.isAuthLoading ? "Loading" : "")
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Sign in options")
            
            if let error = auth.authError {
                InlineErrorView(error: error)
                    .padding(.top)
            }
            
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Sign in screen")
        .padding(.horizontal, 40)
    }
}


#Preview {
    SignInView()
}
