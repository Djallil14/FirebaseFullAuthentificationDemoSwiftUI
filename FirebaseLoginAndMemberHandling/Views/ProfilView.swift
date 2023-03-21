//
//  ProfilView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI

struct ProfilView: View {
    @StateObject var userAuthentification = UserAuthentification()
    @State var showErrorAlert: Bool = false
    @State var alertErrorTitle: String = ""
    @State var alertErrorDescription: String = ""
    var body: some View {
        if userAuthentification.isLoggedIn {
            VStack {
                Text("You are LoggedIn")
                    .font(.headline)
                Text("Hello \(userAuthentification.user?.displayName ?? userAuthentification.user?.email ?? "")")
                    .font(.headline)
                Button(action: {
                    do {
                        try userAuthentification.signOut()
                    } catch {
                        alertErrorTitle = "An Error Happened"
                        alertErrorDescription = error.localizedDescription
                        showErrorAlert.toggle()
                    }
                }) {
                    FullWidthCapsuleButtonLabel(title: "Sign Out")
                }
            }
            .padding()
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text(alertErrorTitle),
                    message: Text(alertErrorDescription),
                    dismissButton: .default(Text("Got it!"))
                )
            }
        } else {
            LoginView(userAuthentification: userAuthentification)
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
