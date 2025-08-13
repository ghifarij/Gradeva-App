//
//  DatabaseModel.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import Foundation
import FirebaseFirestore

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    
    var db: Firestore
    
    init () {
        self.db = Firestore.firestore()
    }
}
