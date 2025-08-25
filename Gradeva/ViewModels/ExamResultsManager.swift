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
    // Immediate per-student mutation (deprecated in favor of batchUpdateScores)
    func updateScore(examId: String, studentId: String, score: Double?) {
        // Intentionally left to no-op to prevent immediate remote writes.
        // Kept for backward compatibility with existing call sites.
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

    // MARK: - Batch Updates
    // Apply a batch of score updates (studentId -> score). Does not change comments.
    func batchUpdateScores(examId: String, updates: [String: Double?], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let schoolId = auth.currentUser?.schoolId, let subjectId = subjectsManager.selectedSubject?.id else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing school or subject context"])) )
            return
        }

        // Merge with existing comments so we don't drop them when writing.
        var merged: [String: (score: Double?, comment: String?)] = [:]
        for (studentId, score) in updates {
            let existing = examResults.first { $0.studentID == studentId }
            merged[studentId] = (score: score, comment: existing?.comment)
        }

        examResultServices.batchUpdateExamResults(schoolId: schoolId, subjectId: subjectId, examId: examId, updates: merged) { [weak self] result in
            guard let self else { completion(result); return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Apply updates to local state and then optionally refresh from backend.
                    for (studentId, payload) in merged {
                        let updated = ExamResult(id: studentId, studentID: studentId, score: payload.score, comment: payload.comment)
                        if (payload.score == nil) && ((payload.comment ?? "").isEmpty) {
                            self.examResults.removeAll { $0.studentID == studentId }
                        } else if let idx = self.examResults.firstIndex(where: { $0.studentID == studentId }) {
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
