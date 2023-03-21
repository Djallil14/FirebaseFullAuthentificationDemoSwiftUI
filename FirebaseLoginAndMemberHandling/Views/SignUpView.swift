//
//  ContentView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI

struct SignUpView: View {
    #warning("Deprecated in iOS15+, if you only support those version use dismiss")
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userAuthentification: UserAuthentification
    let validator = Validator.shared
    @State var showErrorAlert: Bool = false
    @State var alertErrorTitle: String = ""
    @State var alertErrorDescription: String = ""
    @State var isEmailCorrect: Bool?
    @State var isPasswordCorrect: Bool?
    @State var makingNetworkCall: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()
            Spacer()
            GenericTextField(value: $userAuthentification.displayName, isCorrect: .constant(nil), prompt: "Your Display Name")
            GenericTextField(value: $userAuthentification.email, isCorrect: $isEmailCorrect, prompt: "Your Email", sfIcon: "envelope")
            SecureGenericTextField(value: $userAuthentification.password, prompt: "Your Password", isCorrect: $isPasswordCorrect)
            SecureGenericTextField(value: $userAuthentification.passwordConfirmation, prompt: "Password Confirmation", sfIcon: "lock.fill", isCorrect: $isPasswordCorrect)
            Spacer()
            Button(action: {
                signUp()
            }) {
                FullWidthCapsuleButtonLabel(title: "Sign Up")
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
    
    private func signUp() {
        withAnimation {
            makingNetworkCall = true
            isEmailCorrect = validator.validateEmail(userAuthentification.email)
            isPasswordCorrect = validator.validatePasswordCreation(userAuthentification.password, userAuthentification.passwordConfirmation)
        }
        guard isEmailCorrect == true, isPasswordCorrect == true else {
            withAnimation {
                makingNetworkCall = false
            }
            return
        }
        userAuthentification.signUp { result, error in
            if let error = error {
                alertErrorTitle = error.title
                alertErrorDescription = error.localizedDescription
                showErrorAlert.toggle()
            } else {
                userAuthentification.addDisplayName { _ in }
                alertErrorTitle = "You are now signed in"
                alertErrorDescription = "Hello \(result?.user.displayName ?? "!") !"
                showErrorAlert.toggle()
            }
            withAnimation {
                makingNetworkCall = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView(
                userAuthentification: .init()
            )
        }
    }
}
