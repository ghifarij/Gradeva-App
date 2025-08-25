//
//  BatchManager.swift
//  Assessio
//
//  Created by Ramdan on 21/08/25.
//

import Foundation
import SwiftUI

class BatchManager: ObservableObject {
    @Published var batches: [Batch] = []
    @Published var currentBatch: Batch?
    @Published var studentCount: Int = 0
    @Published var isLoading = false
    @Published var error: Error?
    
    private let batchServices = BatchServices()
    
    static let shared = BatchManager()
    
    func getBatches(schoolId: String) {
        setLoading(true)
        
        batchServices.getBatches(schoolId: schoolId) { [weak self] result in
            switch result {
            case .success(let batches):
                self?.setBatches(batches: batches)
                self?.setLoading(false)
            case .failure(let error):
                self?.setError(error: error)
                self?.setLoading(false)
            }
        }
    }
    
    func getBatch(schoolId: String, batchId: String) {
        setLoading(true)
        
        batchServices.getBatch(schoolId: schoolId, batchId: batchId) { [weak self] result in
            switch result {
            case .success(let batch):
                self?.setCurrentBatch(batch: batch)
                self?.setLoading(false)
            case .failure(let error):
                self?.setError(error: error)
                self?.setLoading(false)
            }
        }
    }
    
    func getTotalStudentsInBatch(schoolId: String, batchId: String) {
        setLoading(true)
        
        batchServices.getTotalStudentsInBatch(schoolId: schoolId, batchId: batchId) { [weak self] result in
            switch result {
            case .success(let count):
                self?.setStudentCount(count: count)
                self?.setLoading(false)
            case .failure(let error):
                self?.setError(error: error)
                self?.setLoading(false)
            }
        }
    }
    
    private func setBatches(batches: [Batch]) {
        DispatchQueue.main.async {
            withAnimation {
                self.batches = batches
            }
        }
    }
    
    private func setCurrentBatch(batch: Batch) {
        DispatchQueue.main.async {
            withAnimation {
                self.currentBatch = batch
            }
        }
    }
    
    private func setStudentCount(count: Int) {
        DispatchQueue.main.async {
            withAnimation {
                self.studentCount = count
            }
        }
    }
    
    private func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.5)) {
                self.isLoading = loading
            }
        }
    }
    
    private func setError(error: Error) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    func clearError() {
        self.error = nil
    }
}
