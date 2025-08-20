//
//  WelcomeStepView.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import SwiftUI

struct WelcomeStepView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Header Section
            VStack(spacing: 24) {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.accentColor)
                
                VStack(spacing: 12) {
                    Text("Welcome to Gradeva")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    
                    Text("Your all-in-one grading and analytics companion")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    WelcomeStepView()
}
