//
//  FirstLaunchWelcomeView.swift
//  Gradeva
//
//  Created by Claude on 20/08/25.
//

import SwiftUI

struct FirstLaunchWelcomeView: View {
    let onLoginTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // App logo or icon
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .accessibilityHidden(true)
            
            // Welcome text
            VStack(spacing: 16) {
                Text("Welcome to Gradeva")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your comprehensive grading and analytics management solution")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Welcome to Gradeva. Your comprehensive grading and analytics management solution.")
            .accessibilityAddTraits(.isHeader)
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Login button
            Button(action: onLoginTapped) {
                HStack {
                    Text("Login")
                    Image(systemName: "arrow.right")
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .accessibilityLabel("Login")
            .accessibilityHint("Double tap to proceed to login screen")
            .accessibilityAddTraits(.isButton)
            .frame(minHeight: 44) // Ensure minimum touch target size
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Welcome screen")
    }
}

#Preview {
    FirstLaunchWelcomeView(onLoginTapped: {})
}
