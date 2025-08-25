//
//  StudentsManager.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import Foundation
import Combine
import SwiftUI

class StudentsManager: ObservableObject {
    @Published var students: [Student] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let studentServices = StudentServices()
    private var auth = AuthManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = StudentsManager()
    
    private init() {
        // Subscribe to changes in auth.currentUser
        auth.$currentUser
            .compactMap { $0?.schoolId }
            .sink { [weak self] schoolId in
                self?.loadStudents(schoolId: schoolId)
            }
            .store(in: &cancellables)
    }
    
    func loadStudents(schoolId: String) {
        isLoading = true
        studentServices.getStudents(schoolId: schoolId) { result in
            switch result {
            case .success(let students):
                DispatchQueue.main.async {
                    self.students = students
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func clearError() {
        self.error = nil
    }
}
