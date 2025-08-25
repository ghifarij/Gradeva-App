//
//  RegistrationModel.swift
//  Assessio
//
//  Created by Ramdan on 14/08/25.
//

import Foundation
import FirebaseFirestore

enum RegistrationStatus: String, Codable {
    case pending
    case approved
    case rejected
}

class Registration: Codable {
    @DocumentID var id: String?
    var userId: String
    var userName: String?
    var userEmail: String?
    var status: RegistrationStatus
    var schoolId: String?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(
        id: String? = nil,
        userId: String,
        userName: String? = nil,
        userEmail: String? = nil,
        status: RegistrationStatus,
        schoolId: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
        self.status = status
        self.schoolId = schoolId
    }
    
    func copy(
        userId: String? = nil,
        userName: String? = nil,
        userEmail: String? = nil,
        status: RegistrationStatus? = nil,
        schoolId: String? = nil
    ) -> Registration {
        return Registration(
            id: self.id,
            userId: userId ?? self.userId,
            userName: userName ?? self.userName,
            userEmail: userEmail ?? self.userEmail,
            status: status ?? self.status,
            schoolId: schoolId ?? self.schoolId
        )
    }
}
