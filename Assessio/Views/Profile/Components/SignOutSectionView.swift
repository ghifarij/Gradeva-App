//
//  SignOutSectionView.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct SignOutSectionView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    
    var body: some View {
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

#Preview {
    List {
        SignOutSectionView()
    }
}