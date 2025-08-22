//
//  ExamPreviewView.swift
//  Gradeva
//
//  Created by Codex CLI on 22/08/25.
//

import SwiftUI

/// Pure-UI preview for the Exam list screen using hardcoded data.
/// Mirrors ExamListView layout and styling without live data or navigation.
struct ExamPreviewView: View {
    // Two-column grid like ExamListView

    // Hardcoded exams for preview
    private let exams: [Exam] = [
        Exam(id: "ex-1", name: "Theory", maxScore: 100, passingScore: 80),
        Exam(id: "ex-2", name: "Practical", maxScore: 100, passingScore: 75),
        Exam(id: "ex-3", name: "Interview", maxScore: 10, passingScore: 7.5),
        Exam(id: "ex-4", name: "Final Exam", maxScore: 100, passingScore: 85)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(exams, id: \.id) { exam in
                        ExamCard(exam: exam) { /* UI-only preview */ }
                    }
                }
                .padding()
                .accessibilityLabel("Exam list preview")
            }
            .navigationTitle("Assessments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { /* UI-only preview */ }) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("Add assessment")
                    .accessibilityHint("Opens create assessment sheet")
                }
            }
        }
    }
}

#Preview("Exams – Light") {
    ExamPreviewView()
}

