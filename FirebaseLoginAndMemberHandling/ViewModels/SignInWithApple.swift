//
//  SignInWithApple.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.

import SwiftUI
import Foundation
import FirebaseAuth
import AuthenticationServices

class SignInToAppleWithFirebase: ObservableObject {
    private var nonce: String?
    private var idTokenString: String?
    init() { }
    
    func updateNonce(_ nonce: String) {
        self.nonce = nonce
    }
    
    func updateTokenString(_ tokenString: String) {
        self.idTokenString = tokenString
    }
    
    func signInWithFirebase(completion: @escaping (AuthDataResult?, SwiftyAuthErrors?) -> Void) {
        guard let nonce = nonce, let idTokenString = idTokenString, !nonce.isEmpty, !idTokenString.isEmpty else {
            completion(nil, .genericError)
            return
        }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                let formattedError = SwiftyAuthErrors.handleFirebaseAuthErrors(errorCode)
                completion(nil, formattedError)
            } else {
                completion(authResult, nil)
            }
        }
    }
}
