//
//  AuthError.swift
//  Assessio
//
//  Created by Claude Code on 18/08/25.
//

import Foundation

enum AuthError: LocalizedError, Equatable {
    // Apple Sign In Errors
    case nonceNotFound
    case tokenNotFound
    case tokenEncodingFailed
    case appleCredentialMissing
    
    // Google Sign In Errors
    case googleClientIdMissing
    case noWindowScene
    case googleTokenMissing
    
    // Firebase Auth Errors
    case firebaseSignInFailed(String)
    case firebaseSignOutFailed(String)
    case userDataRetrievalFailed(String)
    case userRegistrationFailed(String)
    
    // General Errors
    case networkUnavailable
    case unknownError(String)
    case userCancelled
    
    // Crypto Errors
    case cryptoOperationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .nonceNotFound:
            return "Authentication nonce is missing. Please try signing in again."
        case .tokenNotFound:
            return "Authentication token is missing. Please try signing in again."
        case .tokenEncodingFailed:
            return "Failed to process authentication token. Please try again."
        case .appleCredentialMissing:
            return "Apple ID credential is missing. Please try signing in with Apple again."
        case .googleClientIdMissing:
            return "Google Sign In is not properly configured. Please contact support."
        case .noWindowScene:
            return "Unable to present sign in screen. Please try again."
        case .googleTokenMissing:
            return "Google authentication token is missing. Please try signing in again."
        case .firebaseSignInFailed(let message):
            return "Sign in failed: \(message)"
        case .firebaseSignOutFailed(let message):
            return "Sign out failed: \(message)"
        case .userDataRetrievalFailed(let message):
            return "Failed to retrieve user data: \(message)"
        case .userRegistrationFailed(let message):
            return "Failed to register user: \(message)"
        case .networkUnavailable:
            return "Network connection is unavailable. Please check your internet connection and try again."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        case .userCancelled:
            return "Sign in was cancelled."
        case .cryptoOperationFailed(let message):
            return "Security operation failed: \(message)"
        }
    }
    
    var recoveryMessage: String? {
        switch self {
        case .nonceNotFound, .tokenNotFound, .tokenEncodingFailed, .appleCredentialMissing, .googleTokenMissing:
            return "Please try signing in again."
        case .googleClientIdMissing:
            return "Please contact support for assistance."
        case .noWindowScene:
            return "Please restart the app and try again."
        case .firebaseSignInFailed, .firebaseSignOutFailed:
            return "Please check your internet connection and try again."
        case .userDataRetrievalFailed, .userRegistrationFailed:
            return "Please try again or contact support if the problem persists."
        case .networkUnavailable:
            return "Please check your internet connection and try again."
        case .unknownError:
            return "Please try again or restart the app."
        case .userCancelled:
            return nil
        case .cryptoOperationFailed:
            return "Please try again or restart the app."
        }
    }
}

extension AuthError {
    static func from(_ error: Error) -> AuthError {
        if let authError = error as? AuthError {
            return authError
        }
        
        let nsError = error as NSError
        let errorMessage = error.localizedDescription
        
        // Handle specific error domains and codes
        switch nsError.domain {
        case "com.apple.AuthenticationServices.AuthorizationError":
            switch nsError.code {
            case 1001: // ASAuthorizationErrorCanceled
                return .userCancelled
            case 1004: // ASAuthorizationErrorNotHandled
                return .appleCredentialMissing
            default:
                return .unknownError("Apple Sign-In failed: \(errorMessage)")
            }
            
        case "com.google.GIDSignIn":
            switch nsError.code {
            case -5: // GIDSignInErrorCodeCanceled
                return .userCancelled
            case -2: // GIDSignInErrorCodeNoCurrentUser
                return .googleTokenMissing
            case -4: // GIDSignInErrorCodeHasNoAuthInKeychain
                return .googleTokenMissing
            default:
                return .unknownError("Google Sign-In failed: \(errorMessage)")
            }
            
        default:
            // Map common Firebase Auth error codes
            switch nsError.code {
            case 17009: // FIRAuthErrorCodeNetworkError
                return .networkUnavailable
            case 17011: // FIRAuthErrorCodeUserNotFound
                return .firebaseSignInFailed("User not found")
            case 17020: // FIRAuthErrorCodeNetworkError
                return .networkUnavailable
            case 17999: // FIRAuthErrorCodeUserCancelled  
                return .userCancelled
            default:
                if errorMessage.lowercased().contains("network") {
                    return .networkUnavailable
                } else if errorMessage.lowercased().contains("cancel") {
                    return .userCancelled
                } else {
                    return .unknownError(errorMessage)
                }
            }
        }
    }
}
