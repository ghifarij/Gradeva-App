//
//  StudentModel.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import Foundation
import FirebaseFirestore

class Student: Codable {
    @DocumentID var id: String?
    var name: String
    var photoURL: String?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String? = nil, name: String, photoURL: String? = nil) {
        self.id = id
        self.name = name
        self.photoURL = photoURL
    }
}
