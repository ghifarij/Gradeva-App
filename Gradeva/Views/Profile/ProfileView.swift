//
//  ProfileView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    profileHeader
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
                if viewModel.currentUser != nil {
                    Section("Personal Information") {
                        Label(viewModel.displayName, systemImage: "person.text.rectangle")
                            .accessibilityLabel("Display Name")
                            .accessibilityValue(viewModel.displayName)
                        
                        Label(viewModel.email, systemImage: "envelope")
                            .accessibilityLabel("Email")
                            .accessibilityValue(viewModel.email)
                        
                        HStack {
                            Label(viewModel.accountStatus, systemImage: "checkmark.shield")
                            .foregroundColor(viewModel.accountStatusColor)
                        }
                        .accessibilityLabel("Account Status")
                        .accessibilityValue(viewModel.accountStatus)
                    }
                    
                    Section("School Information") {
                        if viewModel.isSchoolLoading {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                                Text("Loading school information...")
                                    .foregroundColor(.secondary)
                            }
                            .accessibilityLabel("Loading school information")
                        } else {
                            Label(viewModel.schoolName, systemImage: "building.2")
                                .accessibilityLabel("School")
                                .accessibilityValue(viewModel.schoolName)
                        }
                    }
                    
                    Section("Teaching Subjects") {
                        if viewModel.userSubjects.isEmpty {
                            HStack {
                                Image(systemName: "book.closed")
                                    .foregroundColor(.secondary)
                                Text("No subjects assigned")
                                    .foregroundColor(.secondary)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("No subjects assigned")
                        } else {
                            ForEach(Array(viewModel.userSubjects.enumerated()), id: \.element.id) { index, subject in
                                HStack {
                                    Text("\(index + 1).")
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                    Text(subject.name)
                                    Spacer()
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Subject \(index + 1)")
                                .accessibilityValue(subject.name)
                            }
                        }
                    }
                    
                    Section {
                        Button(action: viewModel.showSignOutAlert) {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Sign out")
                        .accessibilityHint("Double tap to sign out of your account")
                    }
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
        }
        .alert("Sign Out", isPresented: $viewModel.showingSignOutAlert) {
            Button("Cancel", role: .cancel) {
                // Cancel action
            }
            .accessibilityLabel("Cancel")
            .accessibilityHint("Dismiss the sign out dialog and stay signed in")
            
            Button("Sign Out", role: .destructive) {
                viewModel.signOut()
            }
            .accessibilityLabel("Confirm sign out")
            .accessibilityHint("Sign out of your account and return to the login screen")
        } message: {
            Text("Are you sure you want to sign out?")
                .accessibilityLabel("Confirmation message")
                .accessibilityValue("Are you sure you want to sign out?")
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: viewModel.photoURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("default-avatar")
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 100, height: 100)
            .clipped()
            .clipShape(Circle())
            .accessibilityHidden(true)

            if viewModel.displayName != "Not set" {
                Text(viewModel.displayName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .accessibilityAddTraits(.isHeader)
            }
            
            if viewModel.email != "Not set" {
                Text(viewModel.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Profile Information")
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

#Preview {
    ProfileView()
}
