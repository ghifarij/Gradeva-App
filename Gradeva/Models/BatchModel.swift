//
//  BatchModel.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import Foundation
import FirebaseFirestore

class Batch: Codable {
    @DocumentID var id: String?
    var name: String
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(name: String) {
        self.name = name
    }
}
