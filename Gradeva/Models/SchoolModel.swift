//
//  SchoolModel.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import Foundation
import FirebaseFirestore

class School: Codable {
    @DocumentID var id: String?
    var name: String
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
