//
//  GradingView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct GradingView: View {
    @ObservedObject private var subjectsManager = SubjectsManager.shared
    @EnvironmentObject private var auth: AuthManager

    // Define the grid layout with two flexible columns.
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                if let error = subjectsManager.errorMessage, !error.isEmpty {
                    InlineErrorView(message: error)
                        .padding(.horizontal)
                }

                let assignedIds = Set(auth.currentUser?.subjectIds ?? [])
                let assignedSubjects = subjectsManager.subjects.filter { subj in
                    if let id = subj.id { return assignedIds.contains(id) }
                    return false
                }

                if assignedSubjects.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "book.closed")
                            .foregroundColor(.secondary)
                        Text("No assigned subjects")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("No assigned subjects")
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(assignedSubjects, id: \.id) { subject in
                            GradingCard(subject: subject)
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Subjects list")
                    }
                    .padding()
                }
            }
            .navigationTitle("Subjects")
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Subject screen")
        }
    }
}

#Preview {
    GradingView()
}
