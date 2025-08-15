//
//  AuthenticationViewModel.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class AuthManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: AppUser?
    @Published var isAuthLoading = false
    
    private var currentNonce: String?
    
    init() {
        // Check if the user logged in Firebase
        if let user = Auth.auth().currentUser {
            self.currentUser = AppUser(fromFirebaseUser: user)
            self.isSignedIn = true
        }
        
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self.currentUser = AppUser(fromFirebaseUser: user)
                    self.isSignedIn = true
                }
            }
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        setLoading(true)
    }
    
    // TODO: Create a better wrapper for this, right now it's duplicated everywhere
    private func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isAuthLoading = loading
        }
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, any Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // TODO: Do proper error handling
                guard let nonce = currentNonce else {
                    print("Nonce doesn't exist.")
                    setLoading(false)
                    return
                }
                
                // TODO: Do proper error handling
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Token is not found.")
                    setLoading(false)
                    return
                }
                
                // TODO: Do proper error handling
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Failed to encode token.")
                    setLoading(false)
                    return
                }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
                
                Auth.auth().signIn(with: credential, completion: signInCallback)
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            setLoading(false)
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
            print("Failed to sign out.")
        }
    }
    
    private func signInCallback(
        authResult: FirebaseAuth.AuthDataResult?,
        error: Error?
    ) {
        if let error = error {
            // TODO: Do proper error handling
            print("Sign In failed. Error: \(error.localizedDescription)")
            setLoading(false)
            return
        }
        
        if let user = authResult?.user {
            // Get user data from firestore
            UserServices().getUser(uid: user.uid) { firestoreResult in
                switch firestoreResult {
                    
                    // Success --> user already exist in firestore, meaning not the first time
                case .success(let userData):
                    DispatchQueue.main.async {
                        self.currentUser = userData
                        self.isSignedIn = true
                    }
                    self.setLoading(false)
                    
                    // Failure --> first time login
                case .failure(let error):
                    // Convert  to AppUser
                    let appUser = AppUser(fromFirebaseUser: user)
                    
                    UserServices()
                        .handleFirstTimeLogin(user: appUser) { registrationResult in
                            switch registrationResult {
                            case .success():
                                DispatchQueue.main.async {
                                    self.currentUser = appUser
                                    self.isSignedIn = true
                                }
                                self.setLoading(false)
                            case .failure(let error):
                                // TODO: Do proper error handling
                                self.setLoading(false)
                                print("Error registering user: \(error.localizedDescription)")
                            }
                        }
                    
                    // TODO: Do proper error handling
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: Helper functions
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
