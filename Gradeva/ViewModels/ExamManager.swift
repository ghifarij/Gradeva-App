//
//  ExamManager.swift
//  Gradeva
//
//  Created by Codex CLI on 21/08/25.
//

import Foundation
import Combine

class ExamManager: ObservableObject {
    @Published var exams: [Exam] = []
    @Published var examResults: [ExamResult] = []
    @Published var selectedExam: Exam?
    @Published var isLoadingExams: Bool = false
    @Published var isLoadingResults: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func loadExams(schoolId: String, subjectId: String) {
        DispatchQueue.main.async {
            self.isLoadingExams = true
            self.errorMessage = nil
        }

        ExamServices().getExams(schoolId: schoolId, subjectId: subjectId) { result in
            DispatchQueue.main.async {
                self.isLoadingExams = false
                switch result {
                case .success(let exams):
                    self.exams = exams
                case .failure(let error):
                    self.errorMessage = "Failed to load exams: \(error.localizedDescription)"
                }
            }
        }
    }

    func loadExam(schoolId: String, subjectId: String, examId: String) {
        ExamServices().getExam(schoolId: schoolId, subjectId: subjectId, examId: examId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let exam):
                    self.selectedExam = exam
                case .failure(let error):
                    self.errorMessage = "Failed to load exam: \(error.localizedDescription)"
                }
            }
        }
    }

    func loadExamResults(schoolId: String, subjectId: String, examId: String) {
        DispatchQueue.main.async {
            self.isLoadingResults = true
            self.errorMessage = nil
        }

        ExamServices().getExamResults(schoolId: schoolId, subjectId: subjectId, examId: examId) { result in
            DispatchQueue.main.async {
                self.isLoadingResults = false
                switch result {
                case .success(let results):
                    self.examResults = results
                case .failure(let error):
                    self.errorMessage = "Failed to load results: \(error.localizedDescription)"
                }
            }
        }
    }
}

