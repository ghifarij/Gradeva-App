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
    
    func clearError() {
        self.error = nil
    }
}
