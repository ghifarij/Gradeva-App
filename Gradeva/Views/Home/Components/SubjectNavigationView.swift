//
//  SubjectNavigationView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct SubjectNavigationView: View {
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var subjectsManager = SubjectsManager.shared
    @StateObject private var viewModel = HeaderCardViewModel()
    
    private var otherSubjects: [Subject] {
        subjectsManager.subjects.filter { subject in
            subject.id != subjectsManager.selectedSubject?.id
        }
    }
    
    var body: some View {
        HStack {
            Button(action: viewModel.goToPrevSubject) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Color.appPrimary)
            .clipShape(Circle())
            .accessibilityLabel("Previous subject")
            .accessibilityValue(viewModel.previousSubject?.name ?? "None")
            .accessibilityHint("Double tap to switch to \(viewModel.previousSubject?.name ?? "previous subject")")
            .accessibilityAddTraits(.isButton)
            .disabled(!viewModel.canNavigateToPrevious)
            .opacity(viewModel.canNavigateToPrevious ? 1.0 : 0.5)
            
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
            
            Button(action: viewModel.goToNextSubject) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Color.appPrimary)
            .clipShape(Circle())
            .accessibilityLabel("Next subject")
            .accessibilityValue(viewModel.nextSubject?.name ?? "None")
            .accessibilityHint("Double tap to switch to \(viewModel.nextSubject?.name ?? "next subject")")
            .accessibilityAddTraits(.isButton)
            .disabled(!viewModel.canNavigateToNext)
            .opacity(viewModel.canNavigateToNext ? 1.0 : 0.5)
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
