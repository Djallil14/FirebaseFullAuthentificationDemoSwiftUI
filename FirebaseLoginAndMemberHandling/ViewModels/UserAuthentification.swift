//
//  UserAuthentificationViewModel.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI
import FirebaseAuth

class UserAuthentification: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var isLoggedIn: Bool = false

    private(set) var user: User? {
        didSet {
            if user != nil {
                isLoggedIn = true
            }
            objectWillChange.send()
        }
    }
    
    
    init() {
        listenToAuthState()
    }
    
    private func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self, let user = user else {
                return
            }
            self.user = User(
                uuid: user.uid,
                displayName: user.displayName,
                email: user.email
            )
        }
    }
    
    func signUp(completion: @escaping (AuthDataResult?, SwiftyAuthErrors?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                let formattedError = SwiftyAuthErrors.handleFirebaseAuthErrors(errorCode)
                completion(nil, formattedError)
            } else {
                self.user = User(
                    uuid: result!.user.uid,
                    displayName: result?.user.displayName,
                    email: result?.user.email
                )
            }
        }
    }
    
    func addDisplayName(completion: @escaping(SwiftyAuthErrors?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                // We have an error
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                let formattedError = SwiftyAuthErrors.handleFirebaseAuthErrors(errorCode)
                completion(formattedError)
            } else {
                self.user?.displayName = self.displayName
                completion(nil)
            }
        }
    }
    
    func setAppleUser(user: User) {
        self.user = user
    }
    
    func changeEmail(newEmail: String, completion: @escaping (SwiftyAuthErrors?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        user.updateEmail(to: newEmail) { error in
            if let error = error {
                // We have an error
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                let formattedError = SwiftyAuthErrors.handleFirebaseAuthErrors(errorCode)
                completion(formattedError)
            } else {
                completion(nil)
            }
        }
    }
    
    func signIn(
        completion: @escaping (AuthDataResult?, SwiftyAuthErrors?) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
            guard let self = self else {
                completion(nil, .genericError)
                return
            }
            if let error = error {
                // We have an error
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                let formattedError = SwiftyAuthErrors.handleFirebaseAuthErrors(errorCode)
                completion(nil, formattedError)
            } else {
                self.user = User(
                    uuid: result!.user.uid,
                    displayName: result?.user.displayName,
                    email: result?.user.email
                )
                self.isLoggedIn = true
            }
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isLoggedIn = false
        } catch {
            throw error
        }
    }
    
    func deleteUser(completion: @escaping(SwiftyAuthErrors?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                let formattedError = SwiftyAuthErrors.handleFirebaseAuthErrors(errorCode)
                completion(formattedError)
            } else {
                completion(nil)
            }
        }
    }
    
    func changeDisplayName(displayName: String, completion: @escaping(SwiftyAuthErrors?) -> Void){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges {(error) in
            if let error = error {
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                let formattedError = SwiftyAuthErrors.handleFirebaseAuthErrors(errorCode)
                completion(formattedError)
            } else {
                completion(nil)
            }
        }
    }
}
