//
//  GradingStudentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI

enum GradeStatus: String, CaseIterable {
    case all = "All"
    case passed = "Passed"
    case failed = "Need Assist"
    case notGraded = "Not Graded"
}

// CommentOverlayView moved to Views/Grading/Components/CommentOverlayView.swift

struct StudentGradingListView: View {
    let examId: String
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject private var examManager = ExamManager.shared
    @ObservedObject private var studentsManager = StudentsManager.shared
    @ObservedObject private var examResultsManager = ExamResultsManager.shared
    @State private var isShowingEditScores = false
    @State private var searchText = ""
    @State private var selectedStatus: GradeStatus = .all
    @State private var showingCommentFor: StudentGrade?
    @FocusState private var focusedStudentID: UUID?
    // Local observable wrappers around Student + ExamResult
    @State private var studentGrades: [StudentGrade] = []
    
    private var passingGrade: Double? { examManager.selectedExam?.passingScore }
    
    private var filteredStudents: [StudentGrade] {
        var students = studentGrades
        
        // Apply search filter
        if !searchText.isEmpty {
            students = students.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Apply status filter
        if let passing = passingGrade {
            switch selectedStatus {
            case .passed:
                students = students.filter { $0.score != nil && ($0.score ?? 0) >= passing }
            case .failed:
                students = students.filter { $0.score != nil && ($0.score ?? 0) < passing }
            case .notGraded:
                students = students.filter { $0.score == nil }
            case .all:
                break
            }
        } else {
            if selectedStatus == .notGraded {
                students = students.filter { $0.score == nil }
            }
        }
        
        return students
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    if let error = examManager.errorMessage, !error.isEmpty {
                        InlineErrorView(message: error)
                            .padding()
                    }
                    // MARK: Search and Filter UI
                    HStack(spacing: 16) {
                        // SEARCH BAR
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.appPrimary)
                            TextField("Search Student", text: $searchText)
                                .foregroundColor(.appPrimary)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .accessibilityLabel("Search students")
                                .accessibilityHint("Type to filter students by name")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.appPrimary, lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)
                        
                        // DROPDOWN
                        Menu {
                            Picker("All Statuses", selection: $selectedStatus) {
                                ForEach(GradeStatus.allCases, id: \.self) { status in
                                    Text(status.rawValue).tag(status)
                                }
                            }
                            .pickerStyle(.inline)
                        } label: {
                            HStack {
                                Text(selectedStatus.rawValue)
                                    .foregroundColor(.appPrimary)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.appPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.appPrimary, lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                        .accessibilityLabel("Filter by status")
                        .accessibilityValue(selectedStatus.rawValue)
                        .accessibilityHint("Double tap to choose a status filter")
                        .accessibilityAddTraits(.isButton)
                    }
                    .padding()
                    
                    
                    // MARK: Student List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredStudents) { student in
                                StudentCardView(
                                    student: student,
                                    passingGrade: passingGrade,
                                    onScoreChange: { newScore in
                                        examResultsManager.updateScore(examId: examId, studentId: student.studentId, score: newScore)
                                    },
                                    onCommentTap: {
                                        showingCommentFor = student
                                    },
                                    focusedStudent: $focusedStudentID
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Students Grade")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.appBackground)
                .toolbar {
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
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Students grading screen")
                
                // Global comment overlay
                if let student = showingCommentFor {
                    CommentOverlayView(
                        comment: Binding(
                            get: { student.comment },
                            set: { student.comment = $0 }
                        ),
                        isShowing: Binding(
                            get: { showingCommentFor != nil },
                            set: { _ in }
                        ),
                        studentName: student.name,
                        onSave: {
                            examResultsManager.updateComment(examId: examId, studentId: student.studentId, comment: student.comment)
                            showingCommentFor = nil
                        },
                        onCancel: {
                            showingCommentFor = nil
                        }
                    )
                }
            }
        }
        .onAppear {
            // Load selected exam meta if not available (for passing grade)
            if examManager.selectedExam?.id != examId, let schoolId = auth.currentUser?.schoolId, let subjectId = SubjectsManager.shared.selectedSubject?.id {
                examManager.loadExam(schoolId: schoolId, subjectId: subjectId, examId: examId)
            }
            // Ensure data is loaded
            if let schoolId = auth.currentUser?.schoolId {
                studentsManager.loadStudents(schoolId: schoolId)
            }
            if let schoolId = auth.currentUser?.schoolId, let subjectId = SubjectsManager.shared.selectedSubject?.id {
                examResultsManager.loadExamResults(schoolId: schoolId, subjectId: subjectId, examId: examId)
            }
            syncStudentGrades()
        }
        .onReceive(studentsManager.$students) { _ in
            syncStudentGrades()
        }
        .onReceive(examResultsManager.$examResults) { _ in
            syncStudentGrades()
        }
        .sheet(isPresented: $isShowingEditScores) {
            EditScoreView(
                initialMaxScore: examManager.selectedExam?.maxScore,
                initialPassingScore: examManager.selectedExam?.passingScore
            ) { max, pass in
                examManager.updateExamScoresUsingLoadedContext(maxScore: max, passingScore: pass) { _ in }
            }
            .presentationDragIndicator(.visible)
        }
    }

    private func syncStudentGrades() {
        let resultsByStudent = Dictionary(uniqueKeysWithValues: examResultsManager.examResults.map { ($0.studentID, $0) })
        var newGrades: [StudentGrade] = []
        for s in studentsManager.students {
            guard let sid = s.id else { continue }
            let result = resultsByStudent[sid]
            let grade = StudentGrade(studentId: sid, name: s.name, score: result?.score, comment: result?.comment ?? "")
            newGrades.append(grade)
        }
        self.studentGrades = newGrades
    }
}


#Preview {
    StudentGradingListView(examId: "exam_456")
        .environmentObject(AuthManager.shared)
}
