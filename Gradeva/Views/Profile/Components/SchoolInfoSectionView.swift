//
//  SchoolInfoSectionView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct SchoolInfoSectionView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    
    var body: some View {
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
    }
}

#Preview {
    List {
        SchoolInfoSectionView()
    }
}