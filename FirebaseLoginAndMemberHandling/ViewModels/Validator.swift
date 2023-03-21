//
//  Validator.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-21.
//

import Foundation

class Validator {
    
    static let shared = Validator()
    
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            return false
        } else {
            let emailPattern = #"^\S+@\S+\.\S+$"#
            let result = email.range(
                of: emailPattern,
                options: .regularExpression
            )
            if result != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    func validatePassword(_ password: String) -> Bool {
        if password.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func validatePasswordCreation(_ password: String, _ confirmationPassword: String) -> Bool {
        guard !password.isEmpty, !confirmationPassword.isEmpty else {
            return false
        }
        // Could add more validation steps, like minimum carac etc
        if password == confirmationPassword {
            return true
        } else {
            return false
        }
    }
}
