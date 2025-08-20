//
//  AuthManager.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: AppUser?
    @Published var isAuthLoading = false
    @Published var authError: AuthError?
    @Published var showingError = false
    
    private let appleSignInService = AppleSignInService()
    private let googleSignInService = GoogleSignInService()
    private let userServices = UserServices()
    private var userListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = AuthManager()
    
    init() {
        if let user = Auth.auth().currentUser {
            getUserDataFromFirestore(user: user)
        }
        
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.getUserDataFromFirestore(user: user)
            } else {
                    // User signed out - clean up listener
                self.stopUserListener()
            }
        }
        
        setupAppLifecycleObservers()
    }
    
    deinit {
        stopUserListener()
        cancellables.removeAll()
    }
    
    private func setUser(user: AppUser) {
        DispatchQueue.main.async {
            withAnimation {
                self.currentUser = user
            }
        }
    }
    
    private func setIsSignedIn(_ isSignedIn: Bool) {
        DispatchQueue.main.async {
            withAnimation {
                self.isSignedIn = isSignedIn
            }
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        setLoading(true)
        appleSignInService.handleSignInWithAppleRequest(request)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, any Error>) {
        appleSignInService.handleSignInWithAppleCompletion(result) { credential, error in
            if let error = error {
                let authError = AuthError.from(error)
                self.handleAuthError(authError)
                return
            }
            
            if let credential = credential {
                Auth.auth().signIn(with: credential, completion: self.signInCallback)
            }
        }
    }
    
    func handleSignInWithGoogle() {
        setLoading(true)
        googleSignInService.signIn { credential, error in
            if let error = error {
                let authError = AuthError.from(error)
                self.handleAuthError(authError)
                return
            }
            
            if let credential = credential {
                Auth.auth().signIn(with: credential, completion: self.signInCallback)
            }
        }
    }
    
    func signOut() {
        do {
            stopUserListener()
            try Auth.auth().signOut()
            self.setIsSignedIn(false)
            DispatchQueue.main.async {
                self.currentUser = nil
                self.clearError()
            }
        } catch {
            let authError = AuthError.firebaseSignOutFailed(error.localizedDescription)
            handleAuthError(authError)
        }
    }
    
    private func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.5)) {
                self.isAuthLoading = loading
            }
        }
    }
    
    private func signInCallback(
        authResult: FirebaseAuth.AuthDataResult?,
        error: Error?
    ) {
        if let error = error {
            let authError = AuthError.firebaseSignInFailed(error.localizedDescription)
            handleAuthError(authError)
            return
        }
    }
    
    private func getUserDataFromFirestore(user: FirebaseAuth.User) {
        setLoading(true)
        startUserListener(uid: user.uid)
        
        userServices.getUser(uid: user.uid) { firestoreResult in
            switch firestoreResult {
            case .success(let userData):
                self.setUser(user: userData)
                self.setIsSignedIn(true)
                self.setLoading(false)
                
            case .failure(_):
                let appUser = AppUser(fromFirebaseUser: user)
                
                self.userServices.handleFirstTimeLogin(user: appUser) { registrationResult in
                    switch registrationResult {
                    case .success():
                        self.setUser(user: appUser)
                        self.setIsSignedIn(true)
                        self.setLoading(false)
                    case .failure(let error):
                        let authError = AuthError.userRegistrationFailed(error.localizedDescription)
                        self.handleAuthError(authError)
                    }
                }
            }
        }
    }
    
    private func handleAuthError(_ error: AuthError) {
        DispatchQueue.main.async {
            // Don't show error UI for user cancellation
            if error == .userCancelled {
                self.setLoading(false)
                return
            }
            
            self.authError = error
            self.showingError = true
            self.setLoading(false)
        }
    }
    
    func clearError() {
        DispatchQueue.main.async {
            self.authError = nil
            self.showingError = false
        }
    }
    
    private func startUserListener(uid: String) {
        // Prevent multiple listeners - always stop existing one first
        stopUserListener()
        
        // Only start listener if user is still signed in
        guard Auth.auth().currentUser?.uid == uid else { return }
        
        userListener = userServices.startUserListener(uid: uid) { [weak self] result in
            switch result {
            case .success(let updatedUser):
                self?.setUser(user: updatedUser)
            case .failure(let error):
                print("User listener error: \(error.localizedDescription)")
            }
        }
    }
    
    private func stopUserListener() {
        userListener?.remove()
        userListener = nil
    }
    
    private func setupAppLifecycleObservers() {
        // Stop listeners when app goes to background to save resources
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.stopUserListener()
            }
            .store(in: &cancellables)
        
        // Restart listeners when app becomes active
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                if let uid = Auth.auth().currentUser?.uid {
                    self?.startUserListener(uid: uid)
                }
            }
            .store(in: &cancellables)
    }
    
    func updateCurrentUser(_ updatedUser: AppUser) {
        setUser(user: updatedUser)
    }
}
