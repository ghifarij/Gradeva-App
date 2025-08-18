//
//  RegistrationService.swift
//  Gradeva
//
//  Created by Claude Code on 18/08/25.
//

import Foundation
import FirebaseFirestore

class RegistrationService {
    let db = DatabaseManager.shared.db
    
    func checkExistingRegistration(email: String, completion: @escaping (Result<Registration?, Error>) -> Void) {
        Task {
            let registrationRef = db.collection("registrations")
            
            do {
                let querySnapshot = try await registrationRef
                    .whereField("userEmail", isEqualTo: email)
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
    
    func registerToQueue(user: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            guard let userEmail = user.email else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User email is required"])))
                return
            }
            
            checkExistingRegistration(email: userEmail) { result in
                switch result {
                case .success(let existingRegistration):
                    if let registration = existingRegistration {
                        // Registration exists, check if approved
                        if let schoolId = registration.schoolId {
                            // Update user with schoolId from approved registration
                            user.schoolId = schoolId
                            
                            // Update registration with current userId
                            guard let registrationId = registration.id else {
                                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get registration id"])))
                                return
                            }
                            
                            guard let userId = user.id else {
                                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get user id"])))
                                return
                            }
                            
                            registration.userId = userId
                            registration.status = .approved
                            
                            self.updateApprovedRegistration(
                                registration: registration,
                                registrationId: registrationId,
                                user: user,
                                completion: completion
                            )
                        } else {
                            // Registration exists but not approved, just pass
                            completion(.success(()))
                        }
                        return
                    }
                    
                    self.createNewRegistration(user: user, completion: completion)
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func updateApprovedRegistration(
        registration: Registration,
        registrationId: String,
        user: AppUser,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Task {
            do {
                // Update registration document
                var registrationData = try Firestore.Encoder().encode(registration)
                registrationData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await db.collection("registrations").document(registrationId).updateData(registrationData)
                
                // Update user document
                UserServices().updateUser(user: user) { updateResult in
                    switch updateResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func createNewRegistration(
        user: AppUser,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Task {
            let registrationRef = db.collection("registrations")
            guard let userId = user.id else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get user id"])))
                return
            }
            
            let registration = Registration(
                userId: userId,
                userName: user.displayName,
                userEmail: user.email,
                status: .pending
            )
            
            do {
                var registrationData = try Firestore.Encoder().encode(registration)
                registrationData["createdAt"] = FieldValue.serverTimestamp()
                registrationData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await registrationRef.addDocument(data: registrationData)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
