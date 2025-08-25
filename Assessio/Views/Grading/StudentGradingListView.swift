//
//  GradingStudentView.swift
//  Assessio
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI
import UIKit

struct StudentGradingListView: View {
    let examId: String
    @StateObject private var viewModel: StudentGradingViewModel
    @ObservedObject private var navManager = NavManager.shared
    @State private var isShowingEditScores = false
    @FocusState private var focusedStudentID: UUID?
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode
    
    init(examId: String) {
        self.examId = examId
        self._viewModel = StateObject(wrappedValue: StudentGradingViewModel(examId: examId))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                if let error = ExamManager.shared.errorMessage, !error.isEmpty {
                    InlineErrorView(message: error)
                        .padding()
                }
                
                SearchAndFilterView(
                    searchText: $viewModel.searchText,
                    selectedStatus: $viewModel.selectedStatus
                )
                .padding()
                
                StudentListView(
                    students: viewModel.filteredStudents,
                    passingGrade: viewModel.passingGrade,
                    focusedStudent: $focusedStudentID,
                    onScoreChange: viewModel.handleScoreChange,
                    onCommentTap: { student in
                        viewModel.originalDraftComment = student.draftComment
                        viewModel.showingCommentFor = student
                    }
                )
                .padding(.horizontal)
            }
            .background(Color.appBackground)
            .safeAreaInset(edge: .bottom) {
                SaveButtonView(
                    hasPendingChanges: !viewModel.pendingScores.isEmpty || !viewModel.pendingComments.isEmpty,
                    isKeyboardVisible: focusedStudentID == nil,
                    onSave: {
                        focusedStudentID = nil
                        viewModel.savePendingChanges()
                    }
                )
            }
            
            CommentOverlayWrapper(
                showingCommentFor: $viewModel.showingCommentFor,
                originalDraftComment: viewModel.originalDraftComment,
                onSave: { student in
                    viewModel.pendingComments[student.studentId] = student.draftComment
                    viewModel.showingCommentFor = nil
                },
                onCancel: { student in
                    student.draftComment = viewModel.originalDraftComment
                    viewModel.showingCommentFor = nil
                }
            )
            SuccessToastView(showSaveToast: $viewModel.showSaveToast)
        }
        .onAppear {
            viewModel.loadInitialData()
        }
        .onReceive(StudentsManager.shared.$students) { _ in
            viewModel.syncStudentGrades()
        }
        .onReceive(ExamResultsManager.shared.$examResults) { _ in
            viewModel.syncStudentGrades()
        }
        .sheet(isPresented: $isShowingEditScores) {
            EditScoreView(
                initialMaxScore: ExamManager.shared.selectedExam?.maxScore,
                initialPassingScore: ExamManager.shared.selectedExam?.passingScore
            ) { max, pass in
                ExamManager.shared.updateExamScoresUsingLoadedContext(maxScore: max, passingScore: pass) { _ in }
            }
            .presentationDragIndicator(.visible)
        }
        .gesture(
            DragGesture()
                .updating(
                    $dragOffset,
                    body: { (value, state, transaction) in
                        if(value.startLocation.x < 20 && value.translation.width > 100) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
        )
        .accessibilityLabel("Students grading screen")
        .accessibilityAddTraits(.isHeader)
        .accessibilityElement(children: .contain)
        .navigationTitle("Students")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navManager.back()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.body)
                    }
                    .foregroundColor(.black)
                }
                .accessibilityLabel("Go back")
                .accessibilityHint("Double tap to return to previous screen")
                .accessibilityAddTraits(.isButton)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isShowingEditScores = true }) {
                    Image(systemName: "pencil.line")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .accessibilityLabel("Edit exam scores")
                .accessibilityHint("Double tap to edit max and passing score")
                .accessibilityAddTraits(.isButton)
            }
            ToolbarItemGroup(placement: .keyboard) {
                if focusedStudentID != nil {
                    Spacer()
                    Button("Done") { focusedStudentID = nil }
                }
            }
        }
        
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StudentGradingListView(examId: "exam_456")
        .environmentObject(AuthManager.shared)
}
