//
//  RegistrationModel.swift
//  Gradeva
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
    
    init(
        id: String? = nil,
        userId: String,
        userName: String? = nil,
        userEmail: String? = nil,
        status: RegistrationStatus
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
        self.status = status
    }
}
