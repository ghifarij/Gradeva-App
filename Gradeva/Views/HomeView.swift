//
//  HomeView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var navManager: NavManager
    
    var body: some View {
        if let user = auth.currentUser {
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
                    auth.signOut()
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
                
                Button("Go to settings") {
                    navManager.push(.settings)
                }
                
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
