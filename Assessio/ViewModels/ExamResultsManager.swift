//
//  ExamResultsManager.swift
//  Assessio
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
