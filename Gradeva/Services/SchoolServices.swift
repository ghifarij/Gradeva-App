//
//  SchoolServices.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import Foundation
import FirebaseFirestore

class SchoolServices {
    let db = DatabaseManager.shared.db
    
    func startSchoolListener(schoolId: String, onUpdate: @escaping (Result<School, Error>) -> Void) -> ListenerRegistration {
        let schoolRef = db.collection("schools").document(schoolId)
        
        return schoolRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                onUpdate(.failure(error))
                return
            }
            
            guard let document = documentSnapshot else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                onUpdate(.failure(error))
                return
            }
            
            do {
                let school = try document.data(as: School.self)
                onUpdate(.success(school))
            } catch {
                onUpdate(.failure(error))
            }
        }
    }
    
}
