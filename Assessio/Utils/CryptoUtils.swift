//
//  CryptoUtils.swift
//  Assessio
//
//  Created by Claude Code on 18/08/25.
//

import Foundation
import CryptoKit

class CryptoUtils {

    static func randomNonceString(length: Int = 32) throws -> String {
        guard length > 0 else {
            throw AuthError.cryptoOperationFailed("Invalid nonce length: \(length)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            var randoms: [UInt8] = []
            
            for _ in 0 ..< 16 {
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    throw AuthError.cryptoOperationFailed("SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                randoms.append(random)
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
    
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
