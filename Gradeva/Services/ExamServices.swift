//
//  ExamServices.swift
//  Gradeva
//
//  Created by Codex CLI on 21/08/25.
//

import Foundation
import FirebaseFirestore

class ExamServices {
    let db = DatabaseManager.shared.db

    func getExams(schoolId: String, subjectId: String, completion: @escaping (Result<[Exam], Error>) -> Void) {
        Task {
            let examsRef = db
                .collection("schools")
                .document(schoolId)
                .collection("subjects")
                .document(subjectId)
                .collection("exams")

            do {
                let snapshots = try await examsRef.getDocuments()
                var exams: [Exam] = []

                snapshots.documents.forEach { document in
                    do {
                        let exam = try document.data(as: Exam.self)
                        exams.append(exam)
                    } catch {
                        // Skip invalid exam documents
                    }
                }

                completion(.success(exams))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func getExam(schoolId: String, subjectId: String, examId: String, completion: @escaping (Result<Exam, Error>) -> Void) {
        Task {
            let examRef = db
                .collection("schools")
                .document(schoolId)
                .collection("subjects")
                .document(subjectId)
                .collection("exams")
                .document(examId)

            do {
                let document = try await examRef.getDocument()
                let exam = try document.data(as: Exam.self)
                completion(.success(exam))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func getExamResults(schoolId: String, subjectId: String, examId: String, completion: @escaping (Result<[ExamResult], Error>) -> Void) {
        Task {
            let resultsRef = db
                .collection("schools")
                .document(schoolId)
                .collection("subjects")
                .document(subjectId)
                .collection("exams")
                .document(examId)
                .collection("results")

            do {
                let snapshots = try await resultsRef.getDocuments()
                var results: [ExamResult] = []

                snapshots.documents.forEach { document in
                    do {
                        let result = try document.data(as: ExamResult.self)
                        results.append(result)
                    } catch {
                        // Skip invalid result documents
                    }
                }

                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

