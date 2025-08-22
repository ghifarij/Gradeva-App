//
//  SubjectNavigationView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct NavigationButton: View {
    let systemName: String
    let action: () -> Void
    let accessibilityLabel: String
    let accessibilityValue: String
    let accessibilityHint: String
    let isEnabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.appPrimary)
        .clipShape(Circle())
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

struct SubjectNavigationView: View {
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var subjectsManager = SubjectsManager.shared
    @StateObject private var viewModel = HeaderCardViewModel()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var isTextLarge: Bool {
        dynamicTypeSize > .xxLarge
    }
    
    private var otherSubjects: [Subject] {
        subjectsManager.subjects.filter { subject in
            subject.id != subjectsManager.selectedSubject?.id
        }
    }
    
    var body: some View {
        DynamicHStack {
            if !isTextLarge {
                NavigationButton(
                    systemName: "chevron.left",
                    action: viewModel.goToPrevSubject,
                    accessibilityLabel: "Previous subject",
                    accessibilityValue: viewModel.previousSubject?.name ?? "None",
                    accessibilityHint: "Double tap to switch to \(viewModel.previousSubject?.name ?? "previous subject")",
                    isEnabled: viewModel.canNavigateToPrevious
                )
            }
            
            Spacer()
            
            VStack {
                Text(auth.currentUser?.displayName ?? "User")
                    .font(.callout)
                    .foregroundStyle(Color.appPrimary)
                
                Text(subjectsManager.selectedSubject?.name ?? "-")
                    .id(subjectsManager.selectedSubject?.name ?? "-")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appPrimary)
                    .contextMenu {
                        ForEach(otherSubjects, id: \.id) { subject in
                            Button(subject.name) {
                                subjectsManager.setSelectedSubject(subject)
                            }
                        }
                    }
                    .multilineTextAlignment(.center)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isStaticText)
            .accessibilityLabel("Current subject")
            .accessibilityValue(subjectsManager.selectedSubject?.name ?? "None")
            .accessibilityActions {
                ForEach(otherSubjects, id: \.id) { subject in
                    Button("Switch to \(subject.name)") {
                        subjectsManager.setSelectedSubject(subject)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                if isTextLarge {
                    NavigationButton(
                        systemName: "chevron.left",
                        action: viewModel.goToPrevSubject,
                        accessibilityLabel: "Previous subject",
                        accessibilityValue: viewModel.previousSubject?.name ?? "None",
                        accessibilityHint: "Double tap to switch to \(viewModel.previousSubject?.name ?? "previous subject")",
                        isEnabled: viewModel.canNavigateToPrevious
                    )
                }
                NavigationButton(
                    systemName: "chevron.right",
                    action: viewModel.goToNextSubject,
                    accessibilityLabel: "Next subject",
                    accessibilityValue: viewModel.nextSubject?.name ?? "None",
                    accessibilityHint: "Double tap to switch to \(viewModel.nextSubject?.name ?? "next subject")",
                    isEnabled: viewModel.canNavigateToNext
                )
            }
        }
        .padding(.horizontal)
        .onChange(of: viewModel.userSubjects.count, {
            subjectsManager.setSelectedSubject(viewModel.userSubjects.first)
        })
    }
}

#Preview {
    SubjectNavigationView()
}
