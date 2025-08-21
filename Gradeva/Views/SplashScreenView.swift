//
//  SplashScreenView.swift
//  Gradeva
//
//  Created by Claude Code on 20/08/25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                
                Text("Gradeva")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .controlSize(.large)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Gradeva app loading")
        .accessibilityValue("Please wait while the app loads")
    }
}

#Preview {
    SplashScreenView()
}