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
    var schoolId: String?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    var subjectIds: [String]?
    
    init(
        uid: String,
        displayName: String? = nil,
        email: String? = nil,
        didCompleteOnboarding: Bool? = nil,
        schoolId: String? = nil,
        subjectIds: [String]? = nil
    ) {
        self.id = uid
        self.displayName = displayName
        self.email = email
        self.didCompleteOnboarding = didCompleteOnboarding
        self.schoolId = schoolId
        self.subjectIds = subjectIds
    }
    
    init(fromFirebaseUser user: FirebaseAuth.User) {
        self.id = user.uid
        self.displayName = user.displayName
        self.email = user.email
    }
    
    func copy(
        displayName: String? = nil,
        email: String? = nil,
        didCompleteOnboarding: Bool? = nil,
        schoolId: String? = nil,
        subjectIds: [String]? = nil
    ) -> AppUser {
        return AppUser(
            uid: self.id ?? "",
            displayName: displayName ?? self.displayName,
            email: email ?? self.email,
            didCompleteOnboarding: didCompleteOnboarding ?? self.didCompleteOnboarding,
            schoolId: schoolId ?? self.schoolId,
            subjectIds: subjectIds ?? self.subjectIds
        )
    }
}
