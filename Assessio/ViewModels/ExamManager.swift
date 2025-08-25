//
//  ExamManager.swift
//  Gradeva
//
//  Created by Codex CLI on 21/08/25.
//

import Foundation
import Combine

class ExamManager: ObservableObject {
    static let shared = ExamManager()
    @Published var exams: [Exam] = []
    @Published var examResults: [ExamResult] = []
    @Published var selectedExam: Exam?
    @Published var isLoadingExams: Bool = false
    @Published var isLoadingResults: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedExamSubjectId: String?
    private(set) var selectedExamSchoolId: String?

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
                    self.selectedExamSubjectId = subjectId
                    self.selectedExamSchoolId = schoolId
                case .failure(let error):
                    self.errorMessage = "Failed to load exam: \(error.localizedDescription)"
                }
            }
        }
    }

    func selectExam(schoolId: String, subjectId: String, exam: Exam) {
        DispatchQueue.main.async {
            self.selectedExamSchoolId = schoolId
            self.selectedExamSubjectId = subjectId
            self.selectedExam = exam
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

    func createExam(schoolId: String, subjectId: String, name: String, maxScore: Double, passingScore: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Assessment name cannot be empty"])) )
            return
        }
        guard maxScore > 0 else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Max score must be greater than 0"])) )
            return
        }
        guard passingScore >= 0 && passingScore <= maxScore else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Passing score must be between 0 and max score"])) )
            return
        }

        let newExam = Exam(name: trimmed, maxScore: maxScore, passingScore: passingScore)

        ExamServices().createExam(schoolId: schoolId, subjectId: subjectId, exam: newExam) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func updateExamScores(schoolId: String, subjectId: String, examId: String, maxScore: Double, passingScore: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard maxScore > 0 else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Max score must be greater than 0"])) )
            return
        }
        guard passingScore >= 0 && passingScore <= maxScore else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Passing score must be between 0 and max score"])) )
            return
        }

        ExamServices().updateExamScores(schoolId: schoolId, subjectId: subjectId, examId: examId, maxScore: maxScore, passingScore: passingScore) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func updateExamScoresUsingLoadedContext(maxScore: Double, passingScore: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let subjectId = selectedExamSubjectId, let schoolId = selectedExamSchoolId, let examId = selectedExam?.id else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing subject context for the exam"])) )
            return
        }
        
        selectedExam?.maxScore = maxScore
        selectedExam?.passingScore = passingScore
        
        updateExamScores(schoolId: schoolId, subjectId: subjectId, examId: examId, maxScore: maxScore, passingScore: passingScore) { [weak self] result in
            guard let self else { completion(result); return }
            switch result {
            case .success:
                // Refresh selected exam from Firestore so future sheets show updated values
                self.loadExam(schoolId: schoolId, subjectId: subjectId, examId: examId)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
