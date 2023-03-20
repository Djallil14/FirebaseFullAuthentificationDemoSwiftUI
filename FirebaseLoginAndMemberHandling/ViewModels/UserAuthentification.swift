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
    
    func listenToAuthState() {
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
    
    func signUp(handler: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                #warning("handle error")
            } else {
                self.addDisplayName(self.displayName)
                self.user = User(
                    uuid: result!.user.uid,
                    displayName: result?.user.displayName,
                    email: result?.user.email
                )
            }
        }
    }
    
    /// set a user display name on firestore authentification service
    /// - Parameter name: a name in String format
    func addDisplayName(_ name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        self.user?.displayName = name
        changeRequest?.commitChanges { (error) in
            print("\(error?.localizedDescription ?? "couldn't add a name to the profil")")
        }
    }
    
    func setAppleUser(user: User) {
        self.user = user
    }
    func signIn(
        email: String,
        password: String,
        handler: @escaping (AuthDataResult?, SignInErrors?) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
            guard let self = self else {
                handler(nil, .genericError)
                return
            }
            if let error = error {
                // We have an error
                let nsError = error as NSError
                let errorCode = AuthErrorCode(_nsError: nsError).code
                switch errorCode {
                case .invalidCustomToken, .customTokenMismatch, .invalidCredential:
                    handler(nil, .genericError)
                case .userDisabled, .operationNotAllowed:
                    handler(nil, .genericError)
                case .emailAlreadyInUse:
                    handler(nil, .emailAlreadyInUse)
                case .invalidEmail:
                    handler(nil, .invalidEmail)
                case .wrongPassword:
                    handler(nil, .wrongPassword)
                case .tooManyRequests:
                    handler(nil, .tooManyRequests)
                case .userNotFound:
                    handler(nil, .userNotFound)
                case .accountExistsWithDifferentCredential:
                    handler(nil, .accountExistsWithDifferentCredential)
                case .networkError:
                    handler(nil, .networkError)
                case .weakPassword:
                    handler(nil, .weakPassword)
                case .unverifiedEmail:
                    handler(nil, .unverifiedEmail)
                default:
                    // don't really care about other errors
                    handler(nil, .genericError)
                }
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
    
    func signOut()-> Bool {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isLoggedIn = false
            print("Sign out succesfull")
            #warning("Error handling")
            return true
        } catch {
            return false
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                print("Account Deleted")
#warning("Error handling")

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


