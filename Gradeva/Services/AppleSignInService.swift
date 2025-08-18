//
//  AppleSignInService.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class AppleSignInService: ObservableObject {
    private var currentNonce: String?
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = CryptoUtils.randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoUtils.sha256(nonce)
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
            }
        case .failure(let error):
            completion(nil, error)
        }
    }
}

enum AuthError: LocalizedError {
    case nonceNotFound
    case tokenNotFound
    case tokenEncodingFailed
    case noWindowScene
    
    var errorDescription: String? {
        switch self {
        case .nonceNotFound:
            return "Nonce doesn't exist."
        case .tokenNotFound:
            return "Token is not found."
        case .tokenEncodingFailed:
            return "Failed to encode token."
        case .noWindowScene:
            return "No window scene found."
        }
    }
}