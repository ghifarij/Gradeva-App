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
            Group {
                if viewModel.isSignedIn, let user = viewModel.currentUser {
                    // Signed-in UI
                    VStack(spacing: 16) {
                        Text("Hello,")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text(user.email ?? "User")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        // Optional user id
                        Text("UID: \(user.uid)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer().frame(height: 24)
                        
                        Button(action: {
                            viewModel.signOut()
                        }) {
                            Text("Sign Out")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Dashboard")
                } else {
                    // Not signed in show SignInView
                    SignInView(viewModel: viewModel)
                }
            }
        }
    }
}
