//
//  WelcomeView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var subjectsManager = SubjectsManager()
    
    @State private var name: String = ""
    @State private var selectedSubjects = Set<String>()
    @State private var isLoading = false
    @FocusState private var isNameFieldFocused: Bool
    
    private var canContinue: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !selectedSubjects.isEmpty
    }
    
    private func handleContinue() {
        isLoading = true
        isNameFieldFocused = false
        
        // TODO: Implement onboarding completion logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                VStack(spacing: 16) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.accentColor)
                        .padding(.top, 20)
                    
                    VStack(spacing: 8) {
                        Text("Welcome to Gradeva")
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .multilineTextAlignment(.center)
                        
                        Text("Let's get started by setting up your profile")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Name Input Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("What's your name?")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                    
                    TextField("Enter your full name", text: $name)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isNameFieldFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                        )
                        .focused($isNameFieldFocused)
                        .textInputAutocapitalization(.words)
                        .textContentType(.name)
                }
                
                // Subject Selection Section
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Choose your subjects")
                            .font(.system(.title2, design: .rounded, weight: .semibold))
                        
                        Text("Select the subjects you'll be grading")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    LazyVStack(spacing: 12) {
                        ForEach(subjectsManager.subjects, id: \.id) { subject in
                            SubjectSelection(
                                subject: subject,
                                selectedSubjects: $selectedSubjects
                            )
                        }
                    }
                }
                
                // Continue Button
                VStack(spacing: 16) {
                    Button(action: handleContinue) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.9)
                                    .foregroundStyle(.white)
                            } else {
                                Text("Continue")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(canContinue ? Color.accentColor : Color.gray.opacity(0.3))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!canContinue || isLoading)
                    .animation(.easeInOut(duration: 0.2), value: canContinue)
                    
                    if !selectedSubjects.isEmpty {
                        Text("\(selectedSubjects.count) subject\(selectedSubjects.count == 1 ? "" : "s") selected")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .transition(.opacity)
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 24)
        }
        .onTapGesture {
            isNameFieldFocused = false
        }
    }
}

#Preview {
    WelcomeView()
}
