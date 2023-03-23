//
//  LoggenInView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-23.
//

import SwiftUI

struct LoggenInView: View {
    @ObservedObject var userAuthentification: UserAuthentification
    @State private var showErrorAlert: Bool = false
    @State private var alertErrorTitle: String = ""
    @State private var alertErrorDescription: String = ""
    @State private var showConfirmationAlert: Bool = false
    @State private var confirmationAlert: ConfirmationAlert?
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                VStack {
                    Text("Hello \(userAuthentification.user?.displayName ?? userAuthentification.user?.email ?? "")")
                        .font(.title)
                        .bold()
                }
                Spacer()
            }
            Spacer()
            Button {
                print("change email")
            } label: {
                ProfilButtonLabel(title: "Change Your Name", icon: "person.fill")
            }
            
            Button {
                print("change email")
            } label: {
                ProfilButtonLabel(title: "Change Email", icon: "envelope.fill")
            }
            
            Button {
                print("change email")
            } label: {
                ProfilButtonLabel(title: "Change Password", icon: "lock.fill")
            }
            
            Button {
                showConfirmationAlert = true
                confirmationAlert = .delete
            } label: {
                ProfilButtonLabel(title: "Delete Account", icon: "delete.backward.fill", backgroundColor: .red)
            }
            .padding(.vertical)
            Spacer()
            Button(action: {
                showConfirmationAlert = true
                confirmationAlert = .signOut
            }) {
                FullWidthCapsuleButtonLabel(title: "Sign Out")
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(alertErrorTitle),
                message: Text(alertErrorDescription),
                dismissButton: .default(Text("Got it!"))
            )
        }
        .alert(isPresented: $showConfirmationAlert) {
            Alert(title: Text("Confirmation"), message: Text("Are you sure you want to \(confirmationAlert?.title ?? "")?"), primaryButton: .destructive(Text("Yes")) {
                        if let confirmationAlert = confirmationAlert {
                            switch confirmationAlert {
                            case .delete:
                                delete()
                            case .signOut:
                                signOut()
                            }
                        }
                    }, secondaryButton: .cancel())
                }
    }
    
    private func signOut() {
        do {
            try userAuthentification.signOut()
        } catch {
            alertErrorTitle = "An Error Happened"
            alertErrorDescription = error.localizedDescription
            showErrorAlert.toggle()
        }
    }
    
    private func delete() {
        userAuthentification.deleteUser { error in
            if let error = error {
                alertErrorTitle = error.title
                alertErrorDescription = error.localizedDescription
                showErrorAlert.toggle()
            }
        }
    }
}

struct LoggenInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggenInView(
            userAuthentification: .init()
            )
    }
}
