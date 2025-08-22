//
//  ProfileInfoSectionView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct ProfileInfoSectionView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    
    var body: some View {
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
    }
}

#Preview {
    List {
        ProfileInfoSectionView()
    }
}