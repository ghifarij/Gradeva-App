//
//  WelcomeView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var subjectsManager = SubjectsManager()
    @State private var currentStep = 0
    @State private var name: String = ""
    @State private var selectedSubjects = Set<String>()
    
    private var canContinueFromName: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var canContinueFromSubjects: Bool {
        !selectedSubjects.isEmpty
    }
    
    private func nextStep() {
        withAnimation {
            currentStep += 1
        }
    }
    
    private func previousStep() {
        withAnimation {
            currentStep -= 1
        }
    }
    
    private func finishOnboarding() {
        let subjectIds = Array(selectedSubjects)
        subjectsManager.completeOnboarding(name: name, subjectIds: subjectIds) { result in
            switch result {
            case .success:
                // Onboarding completion is handled by the ViewModel
                break
            case .failure:
                // Error handling is managed by SubjectsManager's errorMessage
                break
            }
        }
    }
    
    private func getNextAction() {
        switch currentStep {
        case 0:
            nextStep()
        case 1:
            if canContinueFromName {
                nextStep()
            }
        case 2:
            if canContinueFromSubjects {
                finishOnboarding()
            }
        default:
            break
        }
    }
    
    var body: some View {
        VStack {
            // Header with step indicator
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentStep ? 1.2 : 1.0)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Onboarding progress")
            .accessibilityValue("Step \(currentStep + 1) of 3")
            .padding(.top)
            
            // Step content with sliding animation
            ZStack {
                switch currentStep {
                case 0:
                    WelcomeStepView()
                        .transition(.blurReplace)
                        .padding(.horizontal, 24)
                case 1:
                    NameStepView(name: $name)
                        .transition(.blurReplace)
                        .padding(.horizontal, 24)
                case 2:
                    SubjectsStepView(selectedSubjects: $selectedSubjects)
                        .environmentObject(subjectsManager)
                        .transition(.blurReplace)
                        // padding set internally
                default:
                    EmptyView()
                }
            }
            .frame(maxHeight: .infinity)
            
            // Bottom navigation
            VStack(spacing: 12) {
                // Back button (outlined)
                if currentStep > 0 {
                    Button(action: previousStep) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .accessibilityHidden(true)
                            Text("Back")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.accentColor, lineWidth: 1)
                        )
                    }
                    .transition(.opacity)
                    .disabled(subjectsManager.isClaimingSubjects)
                    .accessibilityLabel("Back")
                    .accessibilityHint("Double tap to go to previous onboarding step")
                    .accessibilityAddTraits(.isButton)
                }
                
                // Main button
                Button(action: getNextAction) {
                    HStack {
                        if subjectsManager.isClaimingSubjects && currentStep == 2 {
                            ProgressView()
                                .accessibilityLabel("Setting up your account")
                        } else {
                            Text(buttonTitle)
                            Image(systemName: buttonIcon)
                                .accessibilityHidden(true)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(buttonEnabled ? Color.accentColor : Color.gray.opacity(0.3))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .transition(.opacity)
                }
                .disabled(!buttonEnabled || subjectsManager.isClaimingSubjects)
                .accessibilityLabel(buttonTitle)
                .accessibilityHint(buttonHint)
                .accessibilityAddTraits(.isButton)
                .accessibilityValue(buttonEnabled ? "" : "Disabled")
                
                // Error message
                if let errorMessage = subjectsManager.errorMessage {
                    InlineErrorView(message: errorMessage)
                        .transition(.opacity)
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Onboarding navigation")
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var buttonTitle: String {
        switch currentStep {
        case 0: return "Get Started"
        case 1: return "Continue"
        case 2: return "Finish Setup"
        default: return "Continue"
        }
    }
    
    private var buttonIcon: String {
        switch currentStep {
        case 0, 1: return "arrow.right"
        case 2: return "checkmark"
        default: return "arrow.right"
        }
    }
    
    private var buttonEnabled: Bool {
        switch currentStep {
        case 0: return true
        case 1: return canContinueFromName
        case 2: return canContinueFromSubjects
        default: return false
        }
    }
    
    private var buttonHint: String {
        switch currentStep {
        case 0: return "Double tap to start the onboarding process"
        case 1: return canContinueFromName ? "Double tap to continue to subject selection" : "Enter your name to continue"
        case 2: return canContinueFromSubjects ? "Double tap to complete onboarding and start using the app" : "Select at least one subject to continue"
        default: return "Double tap to continue to next step"
        }
    }
}

#Preview {
    WelcomeView()
}
