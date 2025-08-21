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
    
    private var user: AppUser? {
        auth.currentUser
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Hello,")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Text(user?.displayName ?? user?.email ?? "User")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Welcome message for \(user?.displayName ?? user?.email ?? "User")")
            .accessibilityAddTraits(.isHeader)
            
            Text("UID: \(String(describing: user?.id))")
                .font(.caption)
                .foregroundColor(.gray)
                .accessibilityLabel("User ID: \(String(describing: user?.id))")
                .accessibilityAddTraits(.isStaticText)
            
            Spacer().frame(height: 24)
            
            VStack(spacing: 12) {
                Button(action: auth.signOut) {
                    Text("Sign Out")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .accessibilityLabel("Sign Out")
                .accessibilityHint("Double tap to sign out of your account")
                .accessibilityAddTraits(.isButton)
                
                Button("Go to settings") {
                    navManager.push(.settings)
                }
                .accessibilityLabel("Go to settings")
                .accessibilityHint("Double tap to open app settings")
                .accessibilityAddTraits(.isButton)
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Action buttons")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Dashboard")
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Dashboard screen")
        
    }
}

#Preview {
    HomeView()
}
