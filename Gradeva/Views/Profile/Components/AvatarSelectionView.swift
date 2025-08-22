//
//  AvatarSelectionView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct AvatarSelectionView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                    ForEach(1...9, id: \.self) { avatarNumber in
                        let avatarName = "avatar-\(avatarNumber)"
                        Button(action: {
                            viewModel.updateAvatar(avatarName)
                            isPresented = false
                        }) {
                            Image(avatarName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            viewModel.avatar == avatarName ? Color.appPrimary : Color.gray,
                                            lineWidth: viewModel.avatar == avatarName ? 3 : 1
                                        )
                                )
                        }
                        .accessibilityLabel("Avatar \(avatarNumber)")
                        .accessibilityHint("Double tap to select this avatar")
                        .accessibilityAddTraits(viewModel.avatar == avatarName ? .isSelected : [])
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .accessibilityLabel("Done")
                    .accessibilityHint("Close avatar selection")
                }
            }
        }
    }
}

#Preview {
    AvatarSelectionView(isPresented: .constant(true))
}
