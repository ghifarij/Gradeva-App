//
//  UserServices.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import Foundation
import FirebaseFirestore

class UserServices {
    let db = DatabaseManager.shared.db
    
    func getUser(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void)  {
        Task {
            let userRef = db.collection("users").document(uid)
            
            do {
                let document = try await userRef.getDocument()
                let user = try document.data(as: AppUser.self)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createUser(user: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let usersRef = db.collection("users")
            guard let userId = user.id else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not get user id"])))
                return
            }
            
            do {
                let userData = try Firestore.Encoder().encode(
                    user
                )
                
                try await usersRef.document(userId).setData(userData)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func registerToQueue(user: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let registrationRef = db.collection("registrations")
            guard let userId = user.id else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not get user id"])))
                return
            }
            let registration = Registration(
                userId: userId,
                userName: user.displayName,
                userEmail: user.email,
                status: .pending,
            )
            
            do {
                let registrationData = try Firestore.Encoder().encode(
                    registration
                )
                try await registrationRef.addDocument(data: registrationData)
                
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func handleFirstTimeLogin(user: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            createUser(user: user) { result in
                switch result {
                case .success:
                    self.registerToQueue(user: user) { result in
                        switch result {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
