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
    
    init(uuid: String, displayName: String?, email: String?) {
        if let id = UUID(uuidString: uuid) {
            self.uuid = id
        }
        self.email = email
        self.displayName = displayName
    }
}
