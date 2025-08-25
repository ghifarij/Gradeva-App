//
//  ProfileHeaderView.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    @Binding var showingAvatarSelection: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingAvatarSelection = true
            }) {
                ZStack(alignment: .bottomTrailing) {
                    Image(viewModel.avatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .clipShape(Circle())
                    
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 24, height: 24)
                        .background(Color.appPrimary)
                        .clipShape(Circle())
                        .offset(x: -4, y: -4)
                }
            }
            .accessibilityLabel("Change avatar")
            .accessibilityHint("Double tap to select a new avatar")
            .accessibilityElement(children: .combine)
            .accessibilityAction {
                showingAvatarSelection = true
            }

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
    ProfileHeaderView(showingAvatarSelection: .constant(false))
}