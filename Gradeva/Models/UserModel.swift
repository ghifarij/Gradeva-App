//
//  User.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class User: Codable {
    var uid: String
    var displayName: String?
    var email: String?
    var didCompleteOnboarding: Bool?
    
    init(uid: String, displayName: String? = nil, email: String? = nil, didCompleteOnboarding: Bool? = nil) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.didCompleteOnboarding = didCompleteOnboarding
    }
    
    init(fromFirebaseUser user: FirebaseAuth.User) {
        self.uid = user.uid
        self.displayName = user.displayName
        self.email = user.email
        self.getUserData()
    }
    
    func getUserData() {
        UserServices().getUser(uid: uid) { result in
            switch result {
            case .success(let user):
                // TODO: Do something after got user data
                print(user)
            case .failure(let error):
                // TODO: Do something when error occurred
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func initUserData() async {
        // TODO: implement initialize user data when first login. Write to `users/{uid}`
    }
}
