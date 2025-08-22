//
//  GradingExamView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct ExamListView: View {
    let subjectId: String
    @EnvironmentObject private var auth: AuthManager
    @StateObject private var examManager = ExamManager()
    @State private var isShowingSetAssessment = false

    // 2-column grid
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            if examManager.isLoadingExams {
                ProgressView("Loading exams...")
                    .padding()
            }

            if let error = examManager.errorMessage, !error.isEmpty {
                InlineErrorView(message: error)
                    .padding(.horizontal)
            }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(examManager.exams, id: \.id) { exam in
                    ExamCard(exam: exam)
                }
            }
            .padding()
            .accessibilityLabel("Exam list")
        }
        .navigationTitle("Assessments")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingSetAssessment = true
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .accessibilityLabel("Set assessment")
                .accessibilityHint("Double tap to create a new assessment")
                .accessibilityAddTraits(.isButton)
            }
        }
        .onAppear {
            if let schoolId = auth.currentUser?.schoolId {
                examManager.loadExams(schoolId: schoolId, subjectId: subjectId)
            }
        }
        .sheet(isPresented: $isShowingSetAssessment) {
            SetAssessmentView { newAssessmentName, maxScore, passingScore in
                if let schoolId = auth.currentUser?.schoolId {
                    examManager.createExam(
                        schoolId: schoolId,
                        subjectId: subjectId,
                        name: newAssessmentName,
                        maxScore: maxScore,
                        passingScore: passingScore
                    ) { _ in
                        examManager.loadExams(schoolId: schoolId, subjectId: subjectId)
                    }
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationView {
        ExamListView(subjectId: "some_ID")
    }
}
