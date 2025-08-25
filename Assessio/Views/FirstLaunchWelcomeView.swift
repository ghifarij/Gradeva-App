//
//  FirstLaunchWelcomeView.swift
//  Assessio
//
//  Created by Claude on 20/08/25.
//

import SwiftUI

struct FirstLaunchWelcomeView: View {
    let onLoginTapped: () -> Void
    private let backgroundColor = LinearGradient(colors: [Color.appPrimary, Color.appPrimaryDarker], startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("onboarding-bg")
                .resizable()
                .scaledToFill()
                .accessibilityHidden(true)
                .overlay {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.appCard)
                        .accessibilityHidden(true)
                }
            

            VStack(spacing: 40) {
                // Welcome text
                VStack(spacing: 16) {
                    Text("Welcome to Assessio")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Simplify your grading process. Track student performance in just a few taps")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Welcome to Assessio. Simplify your grading process. Track student performance in just a few taps")
                .accessibilityAddTraits(.isHeader)
                
                // Login button
                Button(action: onLoginTapped) {
                    HStack {
                        Text("Get Started")
                        Image(systemName: "arrow.right")
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimary)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .accessibilityLabel("Get Started")
                .accessibilityHint("Double tap to get started")
                .accessibilityAddTraits(.isButton)
                .frame(minHeight: 44) // Ensure minimum touch target size
            }
            .padding(.vertical, 40)
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
            .background(.white)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 32,
                    topTrailingRadius: 32
                )
            )
        }
        .background(backgroundColor)
    }
}

#Preview {
    FirstLaunchWelcomeView(onLoginTapped: {})
}
