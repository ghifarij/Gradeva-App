//
//  GradingExamView.swift
//  Assessio
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct ExamListView: View {
    let subjectId: String
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var navManager = NavManager.shared
    @ObservedObject private var examManager = ExamManager.shared
    @State private var isShowingSetAssessment = false

    var body: some View {
        ScrollView {
            if let error = examManager.errorMessage, !error.isEmpty {
                InlineErrorView(message: error)
                    .padding(.horizontal)
            }

            LazyVStack(spacing: 20) {
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
            SetAssessmentView(onSave: { newAssessmentName, maxScore, passingScore in
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
            })
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationView {
        ExamListView(subjectId: "some_ID")
    }
    .environmentObject(AuthManager.shared)
    .environmentObject(NavManager.shared)
}
