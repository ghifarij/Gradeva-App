//
//  ProfileView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Hello, from ProfileView!")
            .accessibilityLabel("Profile view placeholder")
            .accessibilityHint("This is a placeholder for the profile screen")
            .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    ProfileView()
}
