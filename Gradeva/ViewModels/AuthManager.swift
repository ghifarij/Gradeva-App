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
    
    func handleSignInWithAppleRequest(_ request:
                                      ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result:
                                         Result<ASAuthorization, any Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    print("Nonce doesn't exist.")
                    return
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Token is not found.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Failed to encode token.")
                    return
                }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
                
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Sign In failed. Error: \(error.localizedDescription)")
                            return
                        }
                        
                        if let user = authResult?.user {
                            self.currentUser = AppUser(fromFirebaseUser: user)
                            self.isSignedIn = true
                        }
                    }
                }
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
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
