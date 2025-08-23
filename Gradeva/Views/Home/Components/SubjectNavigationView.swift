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
    let isEnabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.appPrimary)
        .clipShape(Circle())
        .accessibilityHidden(true)
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
            && viewModel.userSubjects.contains(where: { $0.id == subject.id })
        }
    }
    
    var body: some View {
        DynamicHStack {
            if !isTextLarge {
                NavigationButton(
                    systemName: "chevron.left",
                    action: viewModel.goToPrevSubject,
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
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                if isTextLarge {
                    NavigationButton(
                        systemName: "chevron.left",
                        action: viewModel.goToPrevSubject,
                        isEnabled: viewModel.canNavigateToPrevious
                    )
                }
                NavigationButton(
                    systemName: "chevron.right",
                    action: viewModel.goToNextSubject,
                    isEnabled: viewModel.canNavigateToNext
                )
            }
        }
        .padding(.horizontal)
        .onChange(of: viewModel.userSubjects.count, {
            subjectsManager.setSelectedSubject(viewModel.userSubjects.first)
        })
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Current subject")
        .accessibilityValue(subjectsManager.selectedSubject?.name ?? "None")
        .accessibilityActions {
            ForEach(otherSubjects, id: \.id) { subject in
                Button("Switch to \(subject.name)") {
                    subjectsManager.setSelectedSubject(subject)
                }
            }
        }
    }
}

#Preview {
    SubjectNavigationView()
}
