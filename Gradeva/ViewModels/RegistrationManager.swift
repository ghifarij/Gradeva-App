//
//  RegistrationManager.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import Foundation
import Combine

class RegistrationManager: ObservableObject {
    @Published var myRegistration: Registration?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var auth = AuthManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to changes in auth.currentUser
        auth.$currentUser
            .compactMap { $0?.id }
            .sink { [weak self] id in
                self?.loadRegistration(userId: id)
            }
            .store(in: &cancellables)
    }
    
    private func loadRegistration(userId: String) {
        isLoading = true
        RegistrationService()
            .checkExistingRegistration(userId: userId) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.isLoading = false
                    switch result {
                    case .success(let registration):
                        self.myRegistration = registration
                    case .failure(let error):
                        self.errorMessage = "Failed to load registration: \(error.localizedDescription)"
                    }
                }
            }
    }
    
    func registerToDemo() {
        guard let user = auth.currentUser else { return }
        
        isLoading = true
        errorMessage = nil
        
        let updatedUser = user.copy(didCompleteDemoOnboarding: true, schoolId: "demo-school")
        
        UserServices().updateUser(user: updatedUser) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    self.auth.currentUser = updatedUser
                case .failure(let error):
                    self.errorMessage = "Failed to register to demo school: \(error.localizedDescription)"
                }
            }
        }
    }
}
