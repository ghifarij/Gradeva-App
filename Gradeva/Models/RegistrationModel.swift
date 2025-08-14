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
    var status: RegistrationStatus
    var userName: String?
    var userEmail: String?
}
