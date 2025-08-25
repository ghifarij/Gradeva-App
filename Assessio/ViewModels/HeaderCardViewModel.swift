//
//  HeaderCardViewModel.swift
//  Assessio
//
//  Created by Ramdan on 22/08/25.
//

import Foundation
import Combine

class HeaderCardViewModel: ObservableObject {
    private let auth = AuthManager.shared
    private let subjectsManager = SubjectsManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSubjects: [Subject] = []
    
    init() {
        setupListeners()
        updateUserSubjects()
    }
    
    private func setupListeners() {
        auth.$currentUser
            .sink { [weak self] _ in
                self?.updateUserSubjects()
            }
            .store(in: &cancellables)
        
        subjectsManager.$subjects
            .sink { [weak self] _ in
                self?.updateUserSubjects()
            }
            .store(in: &cancellables)
    }
    
    private func updateUserSubjects() {
        guard let subjectIds = auth.currentUser?.subjectIds,
              !subjectIds.isEmpty else {
            userSubjects = []
            return
        }
        
        userSubjects = subjectsManager.subjects.filter { subject in
            guard let subjectId = subject.id else { return false }
            return subjectIds.contains(subjectId)
        }
    }
    
    var currentSubjectPosition: String {
        guard !userSubjects.isEmpty,
              let currentSubject = subjectsManager.selectedSubject,
              let currentIndex = userSubjects.firstIndex(where: { $0.id == currentSubject.id }) else {
            return "No subjects available"
        }
        
        return "Subject \(currentIndex + 1) of \(userSubjects.count)"
    }
    
    var canNavigateToPrevious: Bool {
        return userSubjects.count > 1
    }
    
    var canNavigateToNext: Bool {
        return userSubjects.count > 1
    }
    
    var previousSubject: Subject? {
        guard !userSubjects.isEmpty,
              let currentSubject = subjectsManager.selectedSubject,
              let currentIndex = userSubjects.firstIndex(where: { $0.id == currentSubject.id }) else {
            return nil
        }
        
        let prevIndex = currentIndex == 0 ? userSubjects.count - 1 : currentIndex - 1
        return userSubjects[prevIndex]
    }
    
    var nextSubject: Subject? {
        guard !userSubjects.isEmpty,
              let currentSubject = subjectsManager.selectedSubject,
              let currentIndex = userSubjects.firstIndex(where: { $0.id == currentSubject.id }) else {
            return nil
        }
        
        let nextIndex = currentIndex == userSubjects.count - 1 ? 0 : currentIndex + 1
        return userSubjects[nextIndex]
    }
    
    func goToPrevSubject() {
        guard !userSubjects.isEmpty,
              let currentSubject = subjectsManager.selectedSubject,
              let currentIndex = userSubjects.firstIndex(where: { $0.id == currentSubject.id }) else {
            return
        }
        
        let prevIndex = currentIndex == 0 ? userSubjects.count - 1 : currentIndex - 1
        subjectsManager.setSelectedSubject(userSubjects[prevIndex])
    }
    
    func goToNextSubject() {
        guard !userSubjects.isEmpty,
              let currentSubject = subjectsManager.selectedSubject,
              let currentIndex = userSubjects.firstIndex(where: { $0.id == currentSubject.id }) else {
            return
        }
        
        let nextIndex = currentIndex == userSubjects.count - 1 ? 0 : currentIndex + 1
        subjectsManager.setSelectedSubject(userSubjects[nextIndex])
    }
}
