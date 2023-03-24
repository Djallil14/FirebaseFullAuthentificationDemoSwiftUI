//
//  User.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import Foundation

class User {
    var uuid: UUID?
    var email: String?
    var displayName: String?
    var isSignedInWithApple: Bool?
    
    init(uuid: String, displayName: String?, email: String?, isSignedInWithApple: Bool? = nil) {
        if let id = UUID(uuidString: uuid) {
            self.uuid = id
        }
        self.email = email
        self.displayName = displayName
    }
}
