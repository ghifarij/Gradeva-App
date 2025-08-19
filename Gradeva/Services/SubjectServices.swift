//
//  SubjectServices.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import Foundation
import FirebaseFirestore

class SubjectServices {
    let db = DatabaseManager.shared.db
    
    func getSubjects(schoolId: String, completion: @escaping (Result<[Subject], Error>) -> Void) {
        Task {
            let subjectsRef = db.collection("schools").document(schoolId).collection("subjects")
            
            do {
                let snapshots = try await subjectsRef.getDocuments()
                var subjects: [Subject] = []
                
                snapshots.documents.forEach { document in
                    do {
                        let subject = try document.data(as: Subject.self)
                        subjects.append(subject)
                    } catch {
                        // TODO: error handling
                        print("Error decoding subject: \(error.localizedDescription)")
                    }
                }
                
                completion(.success(subjects))
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
