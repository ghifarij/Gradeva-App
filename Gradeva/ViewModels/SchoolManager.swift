//
//  SchoolManager.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine

class SchoolManager: ObservableObject {
    @Published var currentSchool: School?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let schoolServices = SchoolServices()
    private var schoolListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = SchoolManager()
    
    init() {
        setupAppLifecycleObservers()
    }
    
    deinit {
        stopSchoolListener()
        cancellables.removeAll()
    }
    
    func startSchoolListener(schoolId: String) {
        stopSchoolListener()
        setLoading(true)
        
        schoolListener = schoolServices.startSchoolListener(schoolId: schoolId) { [weak self] result in
            switch result {
            case .success(let school):
                self?.setSchool(school: school)
                self?.setLoading(false)
            case .failure(let error):
                self?.setError(error: error)
                self?.setLoading(false)
            }
        }
    }
    
    func stopSchoolListener() {
        schoolListener?.remove()
        schoolListener = nil
    }
    
    private func setSchool(school: School) {
        DispatchQueue.main.async {
            withAnimation {
                self.currentSchool = school
            }
        }
        
        // Fetch batch data when school changes
        if let activeBatchId = school.activeBatchId,
           let schoolId = school.id {
            BatchManager.shared.getBatch(schoolId: schoolId, batchId: activeBatchId)
            BatchManager.shared.getTotalStudentsInBatch(schoolId: schoolId, batchId: activeBatchId)
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
    
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.stopSchoolListener()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                if let schoolId = self?.currentSchool?.id {
                    self?.startSchoolListener(schoolId: schoolId)
                }
            }
            .store(in: &cancellables)
    }
}
