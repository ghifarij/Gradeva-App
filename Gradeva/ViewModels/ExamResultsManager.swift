//
//  ExamResultsManager.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import Foundation
import Combine
import SwiftUI

class ExamResultsManager: ObservableObject {
    @Published var examResults: [ExamResult] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let examResultServices = ExamResultServices()
    private var auth = AuthManager.shared
    private var subjectsManager = SubjectsManager.shared
    private var examsManager = ExamsManager.shared
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
    
    // MARK: - Updates
    func updateScore(examId: String, studentId: String, score: Double?) {
        guard let schoolId = auth.currentUser?.schoolId, let subjectId = subjectsManager.selectedSubject?.id else { return }

        // Determine current comment if any
        let existing = examResults.first { $0.studentID == studentId }
        let comment = existing?.comment

        if score == nil && (comment == nil || comment?.isEmpty == true) {
            // No score and no comment -> delete
            examResultServices.deleteExamResult(schoolId: schoolId, subjectId: subjectId, examId: examId, studentId: studentId) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.examResults.removeAll { $0.studentID == studentId }
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
            return
        }

        let updated = ExamResult(id: studentId, studentID: studentId, score: score, comment: comment)
        examResultServices.upsertExamResult(schoolId: schoolId, subjectId: subjectId, examId: examId, examResult: updated) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.examResults.firstIndex(where: { $0.studentID == studentId }) {
                        self.examResults[index] = updated
                    } else {
                        self.examResults.append(updated)
                    }
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }

    func updateComment(examId: String, studentId: String, comment: String?) {
        guard let schoolId = auth.currentUser?.schoolId, let subjectId = subjectsManager.selectedSubject?.id else { return }

        let existing = examResults.first { $0.studentID == studentId }
        let score = existing?.score

        if (comment == nil || comment?.isEmpty == true) && score == nil {
            // No comment and no score -> delete
            examResultServices.deleteExamResult(schoolId: schoolId, subjectId: subjectId, examId: examId, studentId: studentId) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.examResults.removeAll { $0.studentID == studentId }
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
            return
        }

        let updated = ExamResult(id: studentId, studentID: studentId, score: score, comment: comment)
        examResultServices.upsertExamResult(schoolId: schoolId, subjectId: subjectId, examId: examId, examResult: updated) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.examResults.firstIndex(where: { $0.studentID == studentId }) {
                        self.examResults[index] = updated
                    } else {
                        self.examResults.append(updated)
                    }
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }

    func clearError() {
        self.error = nil
    }
}
