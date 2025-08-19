//
//  SubjectsManager.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import Foundation
import Combine

class SubjectsManager: ObservableObject {
    @Published var subjects: [Subject] = []
    @Published var isLoading: Bool = false
    
    private var auth = AuthManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
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
                print("Error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
