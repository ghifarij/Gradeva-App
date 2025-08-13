//
//  UserServices.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import Foundation
import FirebaseFirestore

class UserServices {
    private func getUserAsync(uid: String, completion: @escaping (Result<User, Error>) -> Void) async {
        let userRef = db.collection("users").document(uid)
        
        do {
            let document = try await userRef.getDocument()
            let user = try document.data(as: User.self)
            completion(.success(user))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)  {
        Task {
            await getUserAsync(uid: uid, completion: completion)
        }
    }
}
