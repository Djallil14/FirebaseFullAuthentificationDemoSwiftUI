//
//  FirebaseLoginAndMemberHandlingApp.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI
import FirebaseCore

@main
struct FirebaseLoginAndMemberHandlingApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
