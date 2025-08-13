//
//  HomeView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
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
        }
    }
}

#Preview {
    HomeView()
}
