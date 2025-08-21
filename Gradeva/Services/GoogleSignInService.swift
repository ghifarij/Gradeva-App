//
//  GoogleSignInService.swift
//  Gradeva
//
//  Created by Claude Code on 18/08/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class GoogleSignInService {

    func signIn(completion: @escaping (AuthCredential?, Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(nil, AuthError.googleClientIdMissing)
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
            completion(nil, AuthError.noWindowScene)
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                completion(nil, AuthError.googleTokenMissing)
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            completion(credential, nil)
        }
    }
}
