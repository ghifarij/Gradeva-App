//
//  AppleSignInService.swift
//  Gradeva
//
//  Created by Claude Code on 18/08/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class AppleSignInService {
    private var currentNonce: String?
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        do {
            let nonce = try CryptoUtils.randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = CryptoUtils.sha256(nonce)
        } catch {
            currentNonce = nil
        }
    }
    
    func handleSignInWithAppleCompletion(
        _ result: Result<ASAuthorization, any Error>,
        completion: @escaping (AuthCredential?, Error?) -> Void
    ) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    completion(nil, AuthError.nonceNotFound)
                    return
                }
                
                guard let appleIDToken = appleIDCredential.identityToken else {
                    completion(nil, AuthError.tokenNotFound)
                    return
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    completion(nil, AuthError.tokenEncodingFailed)
                    return
                }
                
                let credential = OAuthProvider.appleCredential(
                    withIDToken: idTokenString,
                    rawNonce: nonce,
                    fullName: appleIDCredential.fullName
                )
                
                completion(credential, nil)
            } else {
                completion(nil, AuthError.appleCredentialMissing)
            }
        case .failure(let error):
            completion(nil, error)
        }
    }
}
