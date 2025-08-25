//
//  StudentGradingViewModel.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import Foundation
import SwiftUI
import UIKit

class StudentGradingViewModel: ObservableObject {
    let examId: String
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject private var examManager = ExamManager.shared
    @ObservedObject private var studentsManager = StudentsManager.shared
    @ObservedObject private var examResultsManager = ExamResultsManager.shared
    
    @Published var searchText = ""
    @Published var selectedStatus: GradeStatus = .all
    @Published var showingCommentFor: StudentGrade?
    @Published var originalDraftComment: String = ""
    @Published var studentGrades: [StudentGrade] = []
    @Published var pendingScores: [String: Double?] = [:]
    @Published var pendingComments: [String: String?] = [:]
    @Published var showSaveToast: Bool = false
    
    var passingGrade: Double? { examManager.selectedExam?.passingScore }
    
    var filteredStudents: [StudentGrade] {
        var students = studentGrades
        
        // Apply search filter
        if !searchText.isEmpty {
            students = students.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Apply status filter
        if let passing = passingGrade {
            switch selectedStatus {
            case .passed:
                students = students.filter { $0.committedScore != nil && ($0.committedScore ?? 0) >= passing }
            case .failed:
                students = students.filter { $0.committedScore != nil && ($0.committedScore ?? 0) < passing }
            case .notGraded:
                students = students.filter { $0.committedScore == nil }
            case .all:
                break
            }
        } else {
            if selectedStatus == .notGraded {
                students = students.filter { $0.committedScore == nil }
            }
        }
        
        return students
    }
    
    init(examId: String) {
        self.examId = examId
    }
    
    func syncStudentGrades() {
        let resultsByStudent = Dictionary(uniqueKeysWithValues: examResultsManager.examResults.map { ($0.studentId, $0) })
        var newGrades: [StudentGrade] = []
        for s in studentsManager.students {
            guard let sid = s.id else { continue }
            let result = resultsByStudent[sid]
            let grade = StudentGrade(studentId: sid, name: s.name, score: result?.score, comment: result?.comment ?? "")
            newGrades.append(grade)
        }
        // Replace local list
        self.studentGrades = newGrades
        // Reapply any draft/pending edits so UI reflects unsaved edits
        for grade in self.studentGrades {
            if let pending = pendingScores[grade.studentId] {
                grade.draftScore = pending
            }
            if let pending = pendingComments[grade.studentId] {
                grade.draftComment = pending ?? ""
            }
        }
    }
    
    private func existingScore(for studentId: String) -> Double? {
        examResultsManager.examResults.first(where: { $0.studentId == studentId })?.score
    }
    
    func handleScoreChange(for studentId: String, newScore: Double?) {
        let existing = existingScore(for: studentId)
        pendingScores[studentId] = newScore
        if existing == newScore { pendingScores.removeValue(forKey: studentId) }
    }
    
    func savePendingChanges() {
        // Build unified updates of score + comment per student
        var unified: [String: (score: Double?, comment: String?)] = [:]
        let allStudentIds = Set(pendingScores.keys).union(pendingComments.keys)
        for sid in allStudentIds {
            let score = pendingScores[sid] ?? studentGrades.first(where: { $0.studentId == sid })?.committedScore
            let comment = pendingComments[sid] ?? studentGrades.first(where: { $0.studentId == sid })?.committedComment
            unified[sid] = (score: score, comment: comment)
        }
        examResultsManager.batchUpdateResults(examId: examId, updates: unified) { result in
            switch result {
            case .success:
                // Clear pending and resync UI
                self.pendingScores.removeAll()
                self.pendingComments.removeAll()
                self.showSuccessToast()
                // Optionally refresh from backend to reflect server timestamps
                if let schoolId = self.examManager.selectedExamSchoolId, let subjectId = self.examManager.selectedExamSubjectId {
                    self.examResultsManager.loadExamResults(schoolId: schoolId, subjectId: subjectId, examId: self.examId)
                }
            case .failure:
                break
            }
        }
    }
    
    func showSuccessToast() {
        withAnimation(.spring()) { showSaveToast = true }
        UIAccessibility.post(notification: .announcement, argument: "Changes saved")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut) { self.showSaveToast = false }
        }
    }
    
    func loadInitialData() {
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
}