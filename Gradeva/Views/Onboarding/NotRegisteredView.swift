//
//  NotRegisteredView.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import SwiftUI

struct NotRegisteredView: View {
    @ObservedObject private var auth = AuthManager.shared
    @State private var currentStep = 0
    @State private var name: String = ""
    @State private var isUpdatingUser = false
    
    private let userServices = UserServices()
    
    private var canContinueFromName: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
    
    private func updateUserAndContinue(updatedUser: AppUser) {
        isUpdatingUser = true
        
        userServices.updateUser(user: updatedUser) { result in
            DispatchQueue.main.async {
                self.isUpdatingUser = false
                switch result {
                case .success:
                    // Update the auth manager with the new user data
                    self.auth.updateCurrentUser(updatedUser)
                    self.nextStep()
                case .failure(let error):
                    print("Failed to update user: \(error.localizedDescription)")
                    // Still continue to next step even if save fails
                    self.nextStep()
                }
            }
        }
    }
    
    private func saveNameAndContinue() {
        guard let currentUser = auth.currentUser else { return }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let updatedUser = currentUser.copy(displayName: trimmedName)
        updateUserAndContinue(updatedUser: updatedUser)
    }
    
    
    private func getNextAction() {
        switch currentStep {
        case 0:
            nextStep()
        case 1:
            if canContinueFromName && !isUpdatingUser {
                saveNameAndContinue()
            }
        case 2:
            // Try demo school on finish
            RegistrationManager().registerToDemo()
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
                        .fill(index <= currentStep ? Color.appPrimary : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentStep ? 1.2 : 1.0)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Registration progress")
            .accessibilityValue("Step \(currentStep + 1) of 3")
            .accessibilityHidden(currentStep == 0)
            .padding(.top)
            
            // Step content with sliding animation
            ZStack {
                switch currentStep {
                case 0:
                    WelcomeStepView {
                        getNextAction()
                    }
                    .transition(.opacity)
                case 1:
                    NameStepView(name: $name)
                        .transition(.opacity)
                        .padding(.horizontal, 24)
                case 2:
                    RegistrationStepView()
                        .transition(.opacity)
                        .padding(.horizontal, 24)
                default:
                    EmptyView()
                }
            }
            .frame(maxHeight: .infinity)
            
            // Bottom navigation
            if currentStep > 0 {
                VStack(spacing: 12) {
                    // Back button (outlined)
                    Button(action: previousStep) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .accessibilityHidden(true)
                            Text("Back")
                        }
                        .foregroundStyle(.appPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.appPrimary, lineWidth: 1)
                        )
                    }
                    .opacity(currentStep == 0 ? 0 : 1)
                    .disabled(isUpdatingUser || currentStep == 0)
                    .accessibilityHidden(currentStep == 0)
                    .accessibilityLabel("Back")
                    .accessibilityHint("Double tap to go to previous registration step")
                    .accessibilityAddTraits(.isButton)
                    
                    // Main button
                    Button(action: getNextAction) {
                        HStack {
                            if isUpdatingUser && currentStep == 1 {
                                ProgressView()
                                    .accessibilityLabel("Updating profile")
                            } else {
                                Text(buttonTitle)
                                Image(systemName: buttonIcon)
                                    .accessibilityHidden(true)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(buttonEnabled ? Color.appPrimary : Color.gray.opacity(0.3))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .transition(.opacity)
                    }
                    .disabled(!buttonEnabled || isUpdatingUser)
                    .accessibilityLabel(buttonTitle)
                    .accessibilityHint(buttonHint)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityValue(buttonEnabled ? "" : "Disabled")
                    .accessibilityHidden(currentStep == 0)
                }
                .padding(.bottom, 18)
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Registration navigation")
                .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            // Prefill name field with user's current display name
            if name.isEmpty, let displayName = auth.currentUser?.displayName, !displayName.isEmpty {
                name = displayName
            }
        }
    }
    
    private var buttonTitle: String {
        switch currentStep {
        case 0: return "Get Started"
        case 1: return "Continue"
        case 2: return "Try Demo School"
        default: return "Continue"
        }
    }
    
    private var buttonIcon: String {
        switch currentStep {
        case 0, 1: return "arrow.right"
        case 2: return "play.circle"
        default: return "arrow.right"
        }
    }
    
    private var buttonEnabled: Bool {
        switch currentStep {
        case 0: return true
        case 1: return canContinueFromName && !isUpdatingUser
        case 2: return true
        default: return false
        }
    }
    
    private var buttonHint: String {
        switch currentStep {
        case 0: return "Double tap to start the registration process"
        case 1: return canContinueFromName ? "Double tap to continue to registration instructions" : "Enter your name to continue"
        case 2: return "Double tap to register with demo school and start using the app"
        default: return "Double tap to continue"
        }
    }
}

#Preview {
    NotRegisteredView()
}
