//
//  AuthManager.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: AppUser?
    @Published var isAuthLoading = false
    @Published var authError: AuthError?
    @Published var showingError = false
    
    private let appleSignInService = AppleSignInService()
    private let googleSignInService = GoogleSignInService()
    
    init() {
        if let user = Auth.auth().currentUser {
            getUserDataFromFirestore(user: user)
        }
        
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.getUserDataFromFirestore(user: user)
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
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isSignedIn = false
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
            self.isAuthLoading = loading
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
        UserServices().getUser(uid: user.uid) { firestoreResult in
            switch firestoreResult {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.currentUser = userData
                    self.isSignedIn = true
                }
                self.setLoading(false)
                
            case .failure(let error):
                let appUser = AppUser(fromFirebaseUser: user)
                
                UserServices().handleFirstTimeLogin(user: appUser) { registrationResult in
                    switch registrationResult {
                    case .success():
                        DispatchQueue.main.async {
                            self.currentUser = appUser
                            self.isSignedIn = true
                        }
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
}
