//
//  User.swift
//  Assessio
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
    var didCompleteDemoOnboarding: Bool?
    var schoolId: String?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    var subjectIds: [String]?
    var photoURL: String?
    var avatar: String?
    
    init(
        uid: String,
        displayName: String? = nil,
        email: String? = nil,
        didCompleteOnboarding: Bool? = nil,
        didCompleteDemoOnboarding: Bool? = nil,
        schoolId: String? = nil,
        subjectIds: [String]? = nil,
        photoURL: String? = nil,
        avatar: String? = nil
    ) {
        self.id = uid
        self.displayName = displayName
        self.email = email
        self.didCompleteOnboarding = didCompleteOnboarding
        self.didCompleteDemoOnboarding = didCompleteDemoOnboarding
        self.schoolId = schoolId
        self.subjectIds = subjectIds
        self.photoURL = photoURL
        self.avatar = avatar
    }
    
    init(fromFirebaseUser user: FirebaseAuth.User) {
        self.id = user.uid
        self.displayName = user.displayName
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
    
    func copy(
        displayName: String? = nil,
        email: String? = nil,
        didCompleteOnboarding: Bool? = nil,
        didCompleteDemoOnboarding: Bool? = nil,
        schoolId: String? = nil,
        subjectIds: [String]? = nil,
        photoURL: String? = nil,
        avatar: String? = nil
    ) -> AppUser {
        return AppUser(
            uid: self.id ?? "",
            displayName: displayName ?? self.displayName,
            email: email ?? self.email,
            didCompleteOnboarding: didCompleteOnboarding ?? self.didCompleteOnboarding,
            didCompleteDemoOnboarding: didCompleteDemoOnboarding ?? self.didCompleteDemoOnboarding,
            schoolId: schoolId ?? self.schoolId,
            subjectIds: subjectIds ?? self.subjectIds,
            photoURL: photoURL ?? self.photoURL,
            avatar: avatar ?? self.avatar
        )
    }
}
