//
//  SplashScreenView.swift
//  Assessio
//
//  Created by Claude Code on 20/08/25.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    private let backgroundColor = LinearGradient(colors: [Color.appPrimary, Color.appPrimaryDarker], startPoint: .top, endPoint: .bottom)
    
    private var isTextLarge: Bool {
        return dynamicTypeSize > .xxLarge
    }
    
    var body: some View {
        ZStack {
            VStack {
                DynamicHStack(spacing: 10) {
                    Image("app-icon")
                        .resizable()
                        .if(isTextLarge) {
                            $0.frame(width: 200, height: 200)
                        }
                        .if(!isTextLarge) {
                            $0.frame(width: 60, height: 60)
                        }
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
        .accessibilityLabel("Assessio app loading")
        .accessibilityValue("Please wait while the app loads")
    }
}

#Preview {
    SplashScreenView()
}
