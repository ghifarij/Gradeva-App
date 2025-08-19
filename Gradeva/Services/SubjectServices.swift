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
                        // Skip invalid subject documents and do nothing
                    }
                }
                
                completion(.success(subjects))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func claimSubjects(user: AppUser, subjectIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        // Create new user instance with updated subjects and completion status
        let updatedUser = user.copy(
            didCompleteOnboarding: true,
            subjectIds: subjectIds
        )
        
        // Use UserServices to update the user document
        UserServices().updateUser(user: updatedUser) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
