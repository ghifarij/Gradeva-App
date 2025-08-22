//
//  SubjectsStepView.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import SwiftUI

struct SubjectsStepView: View {
    @EnvironmentObject var subjectsManager: SubjectsManager
    @Binding var selectedSubjects: Set<String>
    
    var body: some View {
        VStack(spacing: 24) {
            // Title Section
            VStack(spacing: 16) {
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.accentColor)
                
                VStack(spacing: 8) {
                    Text("Choose your subjects")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text("Select the subjects you'll be grading")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
            
            // Subject Selection - ScrollView only here
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(subjectsManager.subjects, id: \.id) { subject in
                        SubjectSelection(
                            subject: subject,
                            selectedSubjects: $selectedSubjects
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    SubjectsStepView(
        selectedSubjects: .constant(Set<String>())
    )
    .environmentObject(SubjectsManager.shared)
}
