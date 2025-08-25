//
//  RegistrationService.swift
//  Assessio
//
//  Created by Claude Code on 18/08/25.
//

import Foundation
import FirebaseFirestore

class RegistrationService {
    let db = DatabaseManager.shared.db
    
    func checkExistingRegistration(userId: String, completion: @escaping (Result<Registration?, Error>) -> Void) {
        Task {
            let registrationRef = db.collection("registrations")
            
            do {
                let querySnapshot = try await registrationRef
                    .whereField("userId", isEqualTo: userId)
                    .limit(to: 1)
                    .getDocuments()
                
                if let document = querySnapshot.documents.first {
                    let registration = try document.data(as: Registration.self)
                    completion(.success(registration))
                } else {
                    completion(.success(nil))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
