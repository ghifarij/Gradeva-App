//
//  SubjectsManager.swift
//  Assessio
//
//  Created by Ramdan on 19/08/25.
//

import Foundation
import Combine
import SwiftUI

class SubjectsManager: ObservableObject {
    static let shared = SubjectsManager()
    
    @Published var subjects: [Subject] = []
    @Published var isLoading: Bool = false
    @Published var isClaimingSubjects: Bool = false
    @Published var errorMessage: String?
    @Published var selectedSubject: Subject?
    
    private var auth = AuthManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Subscribe to changes in auth.currentUser
        auth.$currentUser
            .compactMap { $0?.schoolId }
            .sink { [weak self] schoolId in
                self?.loadSubjects(schoolId: schoolId)
            }
            .store(in: &cancellables)
    }
    
    func loadSubjects(schoolId: String) {
        isLoading = true
        SubjectServices().getSubjects(schoolId: schoolId) { result in
            switch result {
            case .success(let subjects):
                DispatchQueue.main.async {
                    self.subjects = subjects
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load subjects: \(error.localizedDescription)"
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func completeOnboarding(name: String, subjectIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = auth.currentUser else {
            DispatchQueue.main.async {
                self.errorMessage = "No current user found"
            }
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user found"])))
            return
        }
        
        DispatchQueue.main.async {
            self.isClaimingSubjects = true
            self.errorMessage = nil
        }
        
        // Create updated user instance
        let updatedUser = currentUser.copy(
            displayName: name.trimmingCharacters(in: .whitespacesAndNewlines),
            didCompleteOnboarding: true
        )
        
        // First, claim the subjects
        SubjectServices().claimSubjects(user: updatedUser, subjectIds: subjectIds) { result in
            switch result {
            case .success:
                // Then update the user with name and completion status
                UserServices().updateUser(user: updatedUser) { updateResult in
                    DispatchQueue.main.async {
                        self.isClaimingSubjects = false
                        
                        switch updateResult {
                        case .success:
                            // User data will update automatically via Firestore listener
                            completion(.success(()))
                        case .failure(let error):
                            self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isClaimingSubjects = false
                    self.errorMessage = "Failed to save subjects: \(error.localizedDescription)"
                }
                completion(.failure(error))
            }
        }
    }
    
    func claimSubjects(subjectIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = auth.currentUser else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user found"])))
            return
        }
        
        DispatchQueue.main.async {
            self.isClaimingSubjects = true
        }
        
        SubjectServices().claimSubjects(user: currentUser, subjectIds: subjectIds) { result in
            DispatchQueue.main.async {
                self.isClaimingSubjects = false
                
                switch result {
                case .success:
                    // User data will update automatically via Firestore listener
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func setSelectedSubject(_ subject: Subject?) {
        selectedSubject = subject
    }
}
