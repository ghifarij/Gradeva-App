//
//  ExamResultServices.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import Foundation
import FirebaseFirestore

class ExamResultServices {
    let db = DatabaseManager.shared.db
    
    func getExamResults(schoolId: String, subjectId: String, examId: String, completion: @escaping (Result<[ExamResult], Error>) -> Void) {
        Task {
            let examResultsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams").document(examId).collection("examResults")
            
            do {
                let snapshots = try await examResultsRef.getDocuments()
                var examResults: [ExamResult] = []
                
                snapshots.documents.forEach { document in
                    do {
                        let examResult = try document.data(as: ExamResult.self)
                        examResults.append(examResult)
                    } catch {
                        // Skip invalid exam result documents and do nothing
                    }
                }
                
                completion(.success(examResults))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createExamResult(schoolId: String, subjectId: String, examId: String, examResult: ExamResult, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examResultsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams").document(examId).collection("examResults")
            
            do {
                var examResultData = try Firestore.Encoder().encode(examResult)
                examResultData["createdAt"] = FieldValue.serverTimestamp()
                examResultData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await examResultsRef.addDocument(data: examResultData)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateExamResult(schoolId: String, subjectId: String, examId: String, examResult: ExamResult, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examResultsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams").document(examId).collection("examResults")
            guard let examResultId = examResult.id else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get exam result id"])))
                return
            }
            
            do {
                var examResultData = try Firestore.Encoder().encode(examResult)
                examResultData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await examResultsRef.document(examResultId).updateData(examResultData)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
