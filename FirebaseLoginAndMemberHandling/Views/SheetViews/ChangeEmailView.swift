//
//  ChangeEmailView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-24.
//

import SwiftUI

struct ChangeEmailView: View {
#warning("Deprecated in iOS15+, if you only support those version use dismiss")
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userAuthentification: UserAuthentification
    let validator = Validator.shared
    @State private var email: String = ""
    @State private var newEmail: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var alertErrorTitle: String = ""
    @State private var alertErrorDescription: String = ""
    @State var isEmailCorrect: Bool?
    @State var isNewEmailCorrect: Bool?
    @State var isPasswordCorrect: Bool?
    @State var makingNetworkCall: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Change Email")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    SmallCloseButtonLabel()
                }
            }
            Spacer()
            GenericTextField(value: $userAuthentification.email, isCorrect: $isEmailCorrect, prompt: "Old Email", sfIcon: "envelope")
            GenericTextField(value: $userAuthentification.email, isCorrect: $isNewEmailCorrect, prompt: "New Email", sfIcon: "envelope.fill")
            SecureGenericTextField(value: $password, prompt: "Password", sfIcon: "lock", isCorrect: $isPasswordCorrect)
            Spacer()
            Button(action: {
                updateEmail()
            }) {
                FullWidthCapsuleButtonLabel(title: "Update Email")
            }
            if makingNetworkCall {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            Spacer()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(alertErrorTitle),
                message: Text(alertErrorDescription),
                dismissButton: .default(Text("Got it!"))
            )
        }
        .disabled(makingNetworkCall)
        .padding()
    }
    
    private func updateEmail() {
        isEmailCorrect = validator.validateEmail(email)
        isNewEmailCorrect = validator.validateEmail(newEmail)
        isPasswordCorrect = validator.validatePassword(password)
        guard isEmailCorrect == true, isPasswordCorrect == true, isNewEmailCorrect == true else {
            withAnimation {
                makingNetworkCall = false
            }
            return
        }
        userAuthentification.changeEmail(email: email, password: password, newEmail: newEmail) { error in
            withAnimation {
                makingNetworkCall = true
            }
            if let error = error {
                alertErrorTitle = error.title
                alertErrorDescription = error.localizedDescription
                showErrorAlert.toggle()
                withAnimation {
                    makingNetworkCall = false
                }
            } else {
                alertErrorTitle = "Email Changed"
                alertErrorDescription = "Email changed successfully!"
                showErrorAlert.toggle()
                withAnimation {
                    makingNetworkCall = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView(userAuthentification: .init())
    }
}
