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
    
    // Upsert by using studentId as the document id
    func upsertExamResult(schoolId: String, subjectId: String, examId: String, examResult: ExamResult, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examResultsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams").document(examId).collection("examResults")
            do {
                var examResultData = try Firestore.Encoder().encode(examResult)
                // Managed timestamps
                if try await examResultsRef.document(examResult.studentId).getDocument().exists {
                    examResultData["updatedAt"] = FieldValue.serverTimestamp()
                } else {
                    examResultData["createdAt"] = FieldValue.serverTimestamp()
                    examResultData["updatedAt"] = FieldValue.serverTimestamp()
                }
                try await examResultsRef.document(examResult.studentId).setData(examResultData, merge: true)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // Batch upsert/delete exam results based on provided updates.
    // Pass a map of studentId -> (score, comment). If both score and comment are nil/empty, the document is deleted.
    func batchUpdateExamResults(
        schoolId: String,
        subjectId: String,
        examId: String,
        updates: [String: (score: Double?, comment: String?)],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Task {
            let examResultsRef = db.collection("schools").document(schoolId)
                .collection("subjects").document(subjectId)
                .collection("exams").document(examId)
                .collection("examResults")

            let batch = db.batch()

            do {
                for (studentId, payload) in updates {
                    let docRef = examResultsRef.document(studentId)
                    let trimmedComment = payload.comment?.trimmingCharacters(in: .whitespacesAndNewlines)
                    let hasComment = (trimmedComment?.isEmpty == false)
                    let hasScore = (payload.score != nil)

                    if !hasComment && !hasScore {
                        batch.deleteDocument(docRef)
                        continue
                    }

                    // Create update data structure
                    let updateData = ExamResultUpdateData(
                        studentId: studentId,
                        score: payload.score,
                        comment: hasComment ? trimmedComment! : nil,
                        updatedAt: FieldValue.serverTimestamp()
                    )

                    var encodedData = try Firestore.Encoder().encode(updateData)
                    
                    // Handle field deletions for nil values
                    if payload.score == nil {
                        encodedData["score"] = FieldValue.delete()
                    }
                    if !hasComment {
                        encodedData["comment"] = FieldValue.delete()
                    }

                    batch.setData(encodedData, forDocument: docRef, merge: true)
                }

                try await batch.commit()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    func deleteExamResult(schoolId: String, subjectId: String, examId: String, studentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examResultsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams").document(examId).collection("examResults")
            do {
                try await examResultsRef.document(studentId).delete()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
