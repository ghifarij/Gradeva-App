//
//  ExamsManager.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import Foundation
import Combine
import SwiftUI

class ExamsManager: ObservableObject {
    @Published var exams: [Exam] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedExam: Exam?
    
    private let examServices = ExamServices()
    private var auth = AuthManager.shared
    private var subjectsManager = SubjectsManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = ExamsManager()
    
    private init() {
        // Subscribe to changes in both schoolId and selectedSubject
        Publishers.CombineLatest(
            auth.$currentUser.compactMap { $0?.schoolId },
            subjectsManager.$selectedSubject.compactMap { $0?.id }
        )
        .sink { [weak self] schoolId, subjectId in
            self?.loadExams(schoolId: schoolId, subjectId: subjectId)
        }
        .store(in: &cancellables)
    }
    
    func loadExams(schoolId: String, subjectId: String) {
        isLoading = true
        examServices.getExams(schoolId: schoolId, subjectId: subjectId) { result in
            switch result {
            case .success(let exams):
                DispatchQueue.main.async {
                    self.exams = exams
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
    
    func setSelectedExam(_ exam: Exam?) {
        selectedExam = exam
    }
}
