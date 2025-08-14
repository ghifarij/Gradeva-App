//
//  User.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AppUser: Codable {
    @DocumentID var id: String?
    var displayName: String?
    var email: String?
    var didCompleteOnboarding: Bool?
    
    init(uid: String, displayName: String? = nil, email: String? = nil, didCompleteOnboarding: Bool? = nil) {
        self.id = uid
        self.displayName = displayName
        self.email = email
        self.didCompleteOnboarding = didCompleteOnboarding
    }
    
    init(fromFirebaseUser user: FirebaseAuth.User) {
        self.id = user.uid
        self.displayName = user.displayName
        self.email = user.email
    }
}
