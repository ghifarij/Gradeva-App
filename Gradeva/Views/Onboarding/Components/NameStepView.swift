//
//  NameStepView.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import SwiftUI

struct NameStepView: View {
    @Binding var name: String
    
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Title Section
            VStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.accentColor)
                
                VStack(spacing: 8) {
                    Text("What's your name?")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us personalize your experience")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Name Input
            TextField("Enter your full name", text: $name)
                .textFieldStyle(.plain)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isNameFieldFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                )
                .focused($isNameFieldFocused)
                .textInputAutocapitalization(.words)
                .textContentType(.name)
                .font(.system(.body, design: .rounded))
            
            Spacer()
        }
        .onTapGesture {
            isNameFieldFocused = false
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if name.isEmpty {
                    isNameFieldFocused = true
                }
            }
        }
    }
}

#Preview {
    NameStepView(
        name: .constant("")
    )
}
