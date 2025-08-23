//
//  SplashScreenView.swift
//  Gradeva
//
//  Created by Claude Code on 20/08/25.
//

import SwiftUI

struct SplashScreenView: View {
    private let backgroundColor = LinearGradient(colors: [Color.appPrimary, Color.appPrimaryDarker], startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        ZStack {
            VStack {
                DynamicHStack(spacing: 10) {
                    Image(systemName: "graduationcap.fill")
                        .font(.largeTitle)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .accessibilityHidden(true)
                    
                    Text("Assessio")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Gradeva app loading")
        .accessibilityValue("Please wait while the app loads")
    }
}

#Preview {
    SplashScreenView()
}
