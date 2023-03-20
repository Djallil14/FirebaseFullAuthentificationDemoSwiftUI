//
//  SignInErrors.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import Foundation

enum SignInErrors: Error {
    case invalidEmail
    case wrongPassword
    case tooManyRequests
    case emailAlreadyInUse
    case userNotFound
    case accountExistsWithDifferentCredential
    case networkError
    case someOneIsAlreadySignedIn
    case weakPassword
    case unverifiedEmail
    case genericError
    
    var title: String {
        switch self {
        case .invalidEmail:
            return "Invalid Email"
        case .wrongPassword:
            return "Wrong Password"
        case .tooManyRequests:
            return "Too Many Requests"
        case .emailAlreadyInUse:
            return "Email Already in use"
        case .userNotFound:
            return "User Not Found"
        case .accountExistsWithDifferentCredential:
            return "Wrong credential"
        case .networkError:
            return "Network Error"
        case .someOneIsAlreadySignedIn:
            return "Someone is already signed in"
        case .weakPassword:
            return "Weak Password"
        case .unverifiedEmail:
            return "Unverified Email"
        case .genericError:
            return "An Error Happend"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return "Email is Invalid"
        case .wrongPassword:
            return "Email is Invalid"
        case .tooManyRequests:
            return "Too many requests, try later"
        case .emailAlreadyInUse:
            return "Email Already in use"
        case .userNotFound:
            return "Email is Invalid"
        case .accountExistsWithDifferentCredential:
            return "Email is Invalid"
        case .networkError:
            return "Email is Invalid"
        case .someOneIsAlreadySignedIn:
            return "Email is Invalid"
        case .weakPassword:
            return "Email is Invalid"
        case .unverifiedEmail:
            return "Email is Invalid"
        case .genericError:
            return "An unknown error just happend"
        }
    }
}
