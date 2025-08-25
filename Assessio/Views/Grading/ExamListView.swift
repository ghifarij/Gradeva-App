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
    
    private var examsGrid: [[Exam]] {
        let exams = examManager.exams
        var grid: [[Exam]] = []
        
        for i in stride(from: 0, to: exams.count, by: 2) {
            let endIndex = min(i + 2, exams.count)
            grid.append(Array(exams[i..<endIndex]))
        }
        
        return grid
    }

    var body: some View {
        ScrollView {
            if let error = examManager.errorMessage, !error.isEmpty {
                InlineErrorView(message: error)
                    .padding(.horizontal)
            }

            VStack(spacing: 16) {
                ForEach(examsGrid.indices, id: \.self) { rowIndex in
                    DynamicHStack(spacing: 16) {
                        ForEach(examsGrid[rowIndex], id: \.id) { exam in
                            ExamCard(exam: exam, subjectId: subjectId)
                        }
                    }
                }
            }
            .padding()
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Exam list")
        }
        .navigationTitle("Exams")
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
                .accessibilityLabel("Create new assessment")
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
