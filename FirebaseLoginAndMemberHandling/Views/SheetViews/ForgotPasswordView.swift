//
//  ForgotPasswordView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var userAuthentification: UserAuthentification
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var isEmailValid: Bool?
    @State private var isEmailSent: Bool = false
    @State private var isMakingNetworkCall = false
    @State var errorTitle: String?
    @State var errorDescription: String?
    private let validator = Validator.shared

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Forgot Password")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    SmallCloseButtonLabel()
                }
            }
            .padding(.bottom)
            GenericTextField(value: $email, isCorrect: $isEmailValid, prompt: "Enter your email")
            Button {
                forgotPassword()
            } label: {
                FullWidthCapsuleButtonLabel(title: "Send email")
            }
            .padding(.vertical)
            
            if isMakingNetworkCall {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            responseHandling()
            Spacer()
        }
        .padding()
        .disabled(isMakingNetworkCall)
    }
    @ViewBuilder
    private func responseHandling() -> some View {
        if isEmailSent {
            Text("An Email has been sent")
                .bold()
                .foregroundColor(.green)
                .font(.callout)
        } else {
            if let errorTitle = errorTitle, let errorDescription = errorDescription {
                VStack {
                    Text(errorTitle)
                        .font(.headline)
                        .foregroundColor(.red)
                    Text(errorDescription)
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private func forgotPassword() {
        isEmailValid = validator.validateEmail(email)
        if isEmailValid == true {
            isMakingNetworkCall = true
            userAuthentification.forgotPassword(email: email) { error in
                if let error = error {
                    errorTitle = error.title
                    errorDescription = error.localizedDescription
                    withAnimation {
                        isMakingNetworkCall = false
                    }
                } else {
                    withAnimation {
                        isEmailSent = true
                        isMakingNetworkCall = false
                    }
                }
            }
           
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(userAuthentification: .init())
    }
}
