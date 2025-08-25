//
//  ExamResultsManager.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import Foundation
import Combine
import SwiftUI
import UIKit

class ExamResultsManager: ObservableObject {
    @Published var examResults: [ExamResult] = []
    @Published var isLoading = false
    @Published var error: Error?
    // Business/UI-driving state for grading view
    @Published var studentGrades: [StudentGrade] = []
    @Published var pendingScores: [String: Double?] = [:]
    @Published var pendingComments: [String: String?] = [:]
    @Published var showSaveToast: Bool = false
    
    private let examResultServices = ExamResultServices()
    private var auth = AuthManager.shared
    private var subjectsManager = SubjectsManager.shared
    private var examsManager = ExamManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = ExamResultsManager()
    
    private init() {
        // Subscribe to changes in schoolId, selectedSubject, and selectedExam
        Publishers.CombineLatest3(
            auth.$currentUser.compactMap { $0?.schoolId },
            subjectsManager.$selectedSubject.compactMap { $0?.id },
            examsManager.$selectedExam.compactMap { $0?.id }
        )
        .sink { [weak self] schoolId, subjectId, examId in
            self?.loadExamResults(schoolId: schoolId, subjectId: subjectId, examId: examId)
        }
        .store(in: &cancellables)
    }
    
    func loadExamResults(schoolId: String, subjectId: String, examId: String) {
        isLoading = true
        examResultServices.getExamResults(schoolId: schoolId, subjectId: subjectId, examId: examId) { result in
            switch result {
            case .success(let examResults):
                DispatchQueue.main.async {
                    self.examResults = examResults
                    // When results change, update composed student list if present
                    self.syncStudentGrades(using: self.studentGrades.map { sg in
                        // best-effort rebuild needs Student list; if we don't have it here,
                        // studentGrades will be updated next time syncStudentGrades(using:) is invoked from the view.
                        // No-op here; we avoid mutating without Student models.
                        return Student(id: sg.studentId, name: sg.name)
                    })
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    // MARK: - Business logic moved from StudentGradingListView

    // Compose StudentGrade objects from Students and current ExamResults,
    // reapplying any pending draft changes so UI reflects unsaved edits.
    func syncStudentGrades(using students: [Student]) {
        let resultsByStudent = Dictionary(uniqueKeysWithValues: examResults.map { ($0.studentId, $0) })
        var newGrades: [StudentGrade] = []
        for s in students {
            guard let sid = s.id else { continue }
            let result = resultsByStudent[sid]
            let grade = StudentGrade(studentId: sid, name: s.name, score: result?.score, comment: result?.comment ?? "")
            newGrades.append(grade)
        }
        // Reapply pending edits
        for grade in newGrades {
            if let pending = pendingScores[grade.studentId] {
                grade.draftScore = pending
            }
            if let pending = pendingComments[grade.studentId] {
                grade.draftComment = pending ?? ""
            }
        }
        DispatchQueue.main.async {
            self.studentGrades = newGrades
        }
    }

    func existingScore(for studentId: String) -> Double? {
        examResults.first(where: { $0.studentId == studentId })?.score
    }

    func handleScoreChange(for studentId: String, newScore: Double?) {
        let existing = existingScore(for: studentId)
        pendingScores[studentId] = newScore
        if existing == newScore { pendingScores.removeValue(forKey: studentId) }
    }

    func savePendingChanges(examId: String, focusedStudentID: inout UUID?) {
        // Prevent keyboard lingering (controlled from the View via FocusState)
        focusedStudentID = nil

        // Build unified updates of score + comment per student
        var unified: [String: (score: Double?, comment: String?)] = [:]
        let allStudentIds = Set(pendingScores.keys).union(pendingComments.keys)
        for sid in allStudentIds {
            let score = pendingScores[sid] ?? studentGrades.first(where: { $0.studentId == sid })?.committedScore
            let comment = pendingComments[sid] ?? studentGrades.first(where: { $0.studentId == sid })?.committedComment
            unified[sid] = (score: score, comment: comment)
        }

        batchUpdateResults(examId: examId, updates: unified) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // Clear pending and resync UI
                self.pendingScores.removeAll()
                self.pendingComments.removeAll()
                self.showSuccessToast()
                // Optionally refresh from backend to reflect server timestamps
                if let schoolId = self.auth.currentUser?.schoolId, let subjectId = self.subjectsManager.selectedSubject?.id {
                    self.loadExamResults(schoolId: schoolId, subjectId: subjectId, examId: examId)
                }
            case .failure:
                break
            }
        }
    }

    func showSuccessToast() {
        DispatchQueue.main.async {
            withAnimation(.spring()) { self.showSaveToast = true }
            UIAccessibility.post(notification: .announcement, argument: "Changes saved")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut) { self.showSaveToast = false }
            }
        }
    }

    // Apply a batch of updates including scores and comments.
    // updates: studentId -> (score, comment)
    func batchUpdateResults(examId: String, updates: [String: (score: Double?, comment: String?)], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let schoolId = auth.currentUser?.schoolId, let subjectId = subjectsManager.selectedSubject?.id else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing school or subject context"])) )
            return
        }

        examResultServices.batchUpdateExamResults(schoolId: schoolId, subjectId: subjectId, examId: examId, updates: updates) { [weak self] result in
            guard let self = self else { completion(result); return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    for (studentId, payload) in updates {
                        let updated = ExamResult(id: studentId, studentId: studentId, score: payload.score, comment: payload.comment)
                        if (payload.score == nil) && ((payload.comment ?? "").isEmpty) {
                            self.examResults.removeAll { $0.studentId == studentId }
                        } else if let idx = self.examResults.firstIndex(where: { $0.studentId == studentId }) {
                            self.examResults[idx] = updated
                        } else {
                            self.examResults.append(updated)
                        }
                    }
                    completion(.success(()))
                case .failure(let error):
                    self.error = error
                    completion(.failure(error))
                }
            }
        }
    }

    func clearError() {
        self.error = nil
    }
}
