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
            let examsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams")
            
            do {
                let snapshots = try await examsRef.getDocuments()
                var exams: [Exam] = []
                
                snapshots.documents.forEach { document in
                    do {
                        let exam = try document.data(as: Exam.self)
                        exams.append(exam)
                    } catch {
                        // Skip invalid exam documents and do nothing
                    }
                }
                
                completion(.success(exams))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createExam(schoolId: String, subjectId: String, exam: Exam, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let examsRef = db.collection("schools").document(schoolId).collection("subjects").document(subjectId).collection("exams")
            
            do {
                var examData = try Firestore.Encoder().encode(exam)
                examData["createdAt"] = FieldValue.serverTimestamp()
                examData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await examsRef.addDocument(data: examData)
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
