//
//  StudentServices.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import Foundation
import FirebaseFirestore

class StudentServices {
    let db = DatabaseManager.shared.db
    
    func getStudents(schoolId: String, completion: @escaping (Result<[Student], Error>) -> Void) {
        Task {
            let studentsRef = db.collection("schools").document(schoolId).collection("students")
            
            do {
                let snapshots = try await studentsRef.getDocuments()
                var students: [Student] = []
                
                snapshots.documents.forEach { document in
                    do {
                        let student = try document.data(as: Student.self)
                        students.append(student)
                    } catch {
                        // Skip invalid student documents and do nothing
                    }
                }
                
                completion(.success(students))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
