//  SchoolAssignedOnboardingView.swift
//  Gradeva
//
//  Created by Copilot on 17/08/25.
//

import SwiftUI

struct SchoolAssignedOnboardingView: View {
    let schoolName: String
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "building.2.crop.circle")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.accentColor)
            Text("You're in! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("You have been approved and assigned to \(schoolName). You can now access all features of Gradeva.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                // Dismiss or continue to app
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    SchoolAssignedOnboardingView(schoolName: "SMA Negeri 1 Bandung")
}
