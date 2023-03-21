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
    
    /// set a user display name on firestore authentification service
    func addDisplayName() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                print("\(error?.localizedDescription ?? "couldn't add a name to the profil")")
            } else {
                self.user?.displayName = self.displayName
            }
        }
    }
    
    func setAppleUser(user: User) {
        self.user = user
    }
    func signIn(
        email: String,
        password: String,
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
            print("Sign out succesfull")
        } catch {
            throw error
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                print("Account Deleted")
            }
        }
    }
    
    func changeDisplayName(displayName: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            print("\(String(describing: error?.localizedDescription))")
        }
    }
}
