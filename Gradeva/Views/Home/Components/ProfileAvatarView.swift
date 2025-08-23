//
//  ProfileAvatarView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct ProfileAvatarView: View {
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var navManager = NavManager.shared
    
    var body: some View {
        Button(action: {
            navManager.push(.profile)
        }) {
            ZStack(alignment: .bottomTrailing) {
                Image(auth.currentUser?.avatar ?? "avatar-1")
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
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
        .accessibilityRemoveTraits(.isImage)
        .accessibilityLabel("Profile picture")
        .accessibilityHint("Double tap to view profile")
    }
}

#Preview {
    ProfileAvatarView()
}
