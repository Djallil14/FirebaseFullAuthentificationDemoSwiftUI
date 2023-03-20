//
//  Tabs.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import Foundation

enum Tabs: String {
    case home = "Home"
    case profil = "Profil"
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .profil:
            return "Profil"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .profil:
            return "person"
        }
    }
}
