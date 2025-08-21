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
                var userData = try Firestore.Encoder().encode(user)
                userData["createdAt"] = FieldValue.serverTimestamp()
                userData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await usersRef.document(userId).setData(userData)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateUser(user: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let usersRef = db.collection("users")
            guard let userId = user.id else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not get user id"])))
                return
            }
            
            do {
                var userData = try Firestore.Encoder().encode(user)
                userData["updatedAt"] = FieldValue.serverTimestamp()
                
                try await usersRef.document(userId).updateData(userData)
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
                    RegistrationService().registerToQueue(user: user) { result in
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
    
    func startUserListener(uid: String, onUpdate: @escaping (Result<AppUser, Error>) -> Void) -> ListenerRegistration {
        let userRef = db.collection("users").document(uid)
        
        return userRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                onUpdate(.failure(error))
                return
            }
            
            guard let document = documentSnapshot else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                onUpdate(.failure(error))
                return
            }
            
            do {
                let user = try document.data(as: AppUser.self)
                onUpdate(.success(user))
            } catch {
                onUpdate(.failure(error))
            }
        }
    }
    
}
