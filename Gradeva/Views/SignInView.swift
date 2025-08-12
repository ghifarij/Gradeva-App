//
//  ContentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    // We will create the ViewModel here and pass it the success action.
    @ObservedObject var viewModel: SignInViewModel

    var body: some View {
        VStack {
            Text("Welcome to Gradeva")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            // The button now calls the ViewModel's handleSignIn method directly.
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    viewModel.handleSignInWithAppleRequest(request)
                },
                onCompletion: { result in
                    viewModel.handleSignInWithAppleCompletion(result)
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(width: 280, height: 45)
            .cornerRadius(8)
        }
        .padding()
    }
}
