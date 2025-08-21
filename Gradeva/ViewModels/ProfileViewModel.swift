//
//  ProfileViewModel.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userSubjects: [Subject] = []
    @Published var isRefreshing = false
    @Published var showingSignOutAlert = false
    
    private let auth = AuthManager.shared
    private let schoolManager = SchoolManager.shared
    private let subjectsManager = SubjectsManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
        loadUserSubjects()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func setupObservers() {
        auth.$currentUser
            .sink { [weak self] _ in
                self?.loadUserSubjects()
            }
            .store(in: &cancellables)
        
        subjectsManager.$subjects
            .sink { [weak self] _ in
                self?.loadUserSubjects()
            }
            .store(in: &cancellables)
    }
    
    func loadUserSubjects() {
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
    
    @MainActor
    func refreshData() async {
        isRefreshing = true
        
        if let schoolId = auth.currentUser?.schoolId {
            subjectsManager.loadSubjects(schoolId: schoolId)
        }
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadUserSubjects()
        
        isRefreshing = false
    }
    
    func signOut() {
        auth.signOut()
    }
    
    func showSignOutAlert() {
        showingSignOutAlert = true
    }
    
    var currentUser: AppUser? {
        auth.currentUser
    }
    
    var currentSchool: School? {
        schoolManager.currentSchool
    }
    
    var isSchoolLoading: Bool {
        schoolManager.isLoading
    }
    
    var displayName: String {
        auth.currentUser?.displayName ?? "Not set"
    }
    
    var email: String {
        auth.currentUser?.email ?? "Not set"
    }
    
    var photoURL: String {
        auth.currentUser?.photoURL ?? ""
    }
    
    var avatar: String {
        auth.currentUser?.avatar ?? "avatar-1"
    }
    
    var accountStatus: String {
        auth.currentUser?.didCompleteOnboarding == true ? "Active" : "Setup Required"
    }
    
    var accountStatusColor: Color {
        auth.currentUser?.didCompleteOnboarding == true ? .green : .orange
    }
    
    var schoolName: String {
        schoolManager.currentSchool?.name ?? "Not assigned"
    }
}