//
//  ChangePasswordView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-24.
//

import SwiftUI

struct ChangePasswordView: View {
#warning("Deprecated in iOS15+, if you only support those version use dismiss")
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userAuthentification: UserAuthentification
    let validator = Validator.shared
    @State private var email: String = ""
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var alertErrorTitle: String = ""
    @State private var alertErrorDescription: String = ""
    @State var isEmailCorrect: Bool?
    @State var isPasswordCorrect: Bool?
    @State var makingNetworkCall: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Change Password")
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
            GenericTextField(value: $email, isCorrect: $isEmailCorrect, prompt: "Your Email", sfIcon: "envelope")
            SecureGenericTextField(value: $oldPassword, prompt: "Old Password", isCorrect: $isPasswordCorrect)
            SecureGenericTextField(value: $newPassword, prompt: "New Password", sfIcon: "lock.fill", isCorrect: $isPasswordCorrect)
            SecureGenericTextField(value: $confirmPassword, prompt: "Password  Confirmation", sfIcon: "lock.fill", isCorrect: $isPasswordCorrect)
            Spacer()
            Button(action: {
                updatePassword()
            }) {
                FullWidthCapsuleButtonLabel(title: "Change Password")
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
    
    private func updatePassword() {
        let isOldPasswordValid = validator.validatePassword(oldPassword)
        let newPasswordValidation = validator.validatePasswordCreation(newPassword, confirmPassword)
        isEmailCorrect = validator.validateEmail(email)
        isPasswordCorrect = isOldPasswordValid && newPasswordValidation
        guard isEmailCorrect == true, isPasswordCorrect == true else {
            withAnimation {
                makingNetworkCall = false
            }
            return
        }
        userAuthentification.changePassword(email: email, password: oldPassword, newPassword: newPassword) { error in
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
                alertErrorTitle = "Password Changed"
                alertErrorDescription = "Password changed successfully!"
                showErrorAlert.toggle()
                withAnimation {
                    makingNetworkCall = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(userAuthentification: .init())
    }
}
