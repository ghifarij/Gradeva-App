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
                print("Apple Sign In Error: \(error.localizedDescription)")
                self.setLoading(false)
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
                print("Google Sign In Error: \(error.localizedDescription)")
                self.setLoading(false)
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
            }
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
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
            print("Sign In failed. Error: \(error.localizedDescription)")
            setLoading(false)
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
                        self.setLoading(false)
                        print("Error registering user: \(error.localizedDescription)")
                    }
                }
                
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
}
