//
//  ProfilView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI

struct ProfilView: View {
    @StateObject var userAuthentification = UserAuthentification()
    var body: some View {
        if userAuthentification.isLoggedIn {
            LoggenInView(
                userAuthentification: userAuthentification
            )
        } else {
            LoginView(
                userAuthentification: userAuthentification
            )
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}

enum ConfirmationAlert {
    case delete
    case signOut
    
    var title: String {
        switch self {
        case .delete:
            return "delete your account"
        case .signOut:
            return "Sign Out"
        }
    }
}
