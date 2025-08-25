//
//  ProfileView.swift
//  Assessio
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    @State private var showingAvatarSelection = false
    
    var body: some View {
        List {
            Section {
                ProfileHeaderView(showingAvatarSelection: $showingAvatarSelection)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            if viewModel.currentUser != nil {
                ProfileInfoSectionView()
                
                SchoolInfoSectionView()
                
                SubjectsSectionView()

                SignOutSectionView()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.refreshData()
        }
        .task {
            await viewModel.refreshData()
        }
        .alert("Sign Out", isPresented: $viewModel.showingSignOutAlert) {
            Button("Cancel", role: .cancel, action: {})
                .accessibilityLabel("Cancel")
                .accessibilityHint("Dismiss the sign out dialog and stay signed in")
            
            Button("Sign Out", role: .destructive, action: viewModel.signOut)
                .accessibilityLabel("Confirm sign out")
                .accessibilityHint("Sign out of your account and return to the login screen")
        } message: {
            Text("Are you sure you want to sign out?")
                .accessibilityLabel("Confirmation message")
                .accessibilityValue("Are you sure you want to sign out?")
        }
        .sheet(isPresented: $showingAvatarSelection) {
            AvatarSelectionView(isPresented: $showingAvatarSelection)
        }
    }
}

#Preview {
    ProfileView()
}
