//
//  BatchServices.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import Foundation
import FirebaseFirestore

class BatchServices {
    let db = DatabaseManager.shared.db
    
    func getBatches(schoolId: String, completion: @escaping (Result<[Batch], Error>) -> Void) {
        Task {
            let batchesRef = db.collection("schools").document(schoolId).collection("batches")
            
            do {
                let snapshots = try await batchesRef.getDocuments()
                var batches: [Batch] = []
                
                snapshots.documents.forEach { document in
                    do {
                        let batch = try document.data(as: Batch.self)
                        batches.append(batch)
                    } catch {
                        // Skip invalid batch documents and do nothing
                    }
                }
                
                completion(.success(batches))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getBatch(schoolId: String, batchId: String, completion: @escaping (Result<Batch, Error>) -> Void) {
        Task {
            let batchRef = db.collection("schools").document(schoolId).collection("batches").document(batchId)
            
            do {
                let document = try await batchRef.getDocument()
                let batch = try document.data(as: Batch.self)
                completion(.success(batch))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTotalStudentsInBatch(schoolId: String, batchId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        Task {
            let studentsRef = db.collection("schools").document(schoolId).collection("students")
                .whereField("batchId", isEqualTo: batchId)
            
            do {
                let snapshot = try await studentsRef.count.getAggregation(source: .server)
                let count = Int(snapshot.count.intValue)
                completion(.success(count))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
