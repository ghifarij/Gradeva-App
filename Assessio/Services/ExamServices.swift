//
//  ExamServices.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
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
    
    // Removed getExamById to keep navigation unchanged and avoid collectionGroup lookups.
    
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
    
    func createExam(schoolId: String, subjectId: String, exam: Exam, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examsRef = db
                .collection("schools")
                .document(schoolId)
                .collection("subjects")
                .document(subjectId)
                .collection("exams")
            
            do {
                var examData = try Firestore.Encoder().encode(exam)
                examData["createdAt"] = FieldValue.serverTimestamp()
                examData["updatedAt"] = FieldValue.serverTimestamp()
                
                if let id = exam.id, !id.isEmpty {
                    try await examsRef.document(id).setData(examData)
                } else {
                    _ = try await examsRef.addDocument(data: examData)
                }
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateExamScores(schoolId: String, subjectId: String, examId: String, maxScore: Double, passingScore: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examRef = db
                .collection("schools")
                .document(schoolId)
                .collection("subjects")
                .document(subjectId)
                .collection("exams")
                .document(examId)
            
            do {
                let updateData = ExamScoreUpdateData(
                    maxScore: maxScore,
                    passingScore: passingScore,
                    updatedAt: FieldValue.serverTimestamp()
                )
                let encodedData = try Firestore.Encoder().encode(updateData)
                try await examRef.updateData(encodedData)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateExam(schoolId: String, subjectId: String, exam: Exam, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams")
            guard let examId = exam.id else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get exam id"])))
                return
            }
            
            do {
                var examData = try Firestore.Encoder().encode(exam)
                examData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await examsRef.document(examId).updateData(examData)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
