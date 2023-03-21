//
//  LoginView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userAuthentification: UserAuthentification
    @StateObject var signInWithAppleVM = SignInToAppleWithFirebase()
    let validator = Validator.shared
    @State var isEmailCorrect: Bool?
    @State var isPasswordCorrect: Bool?
    @State var showSignUpSheet: Bool = false
    @State var makingNetworkCall: Bool = false
    @State var showErrorAlert: Bool = false
    @State var alertErrorTitle: String = ""
    @State var alertErrorDescription: String = ""

    var body: some View {
        VStack {
            Spacer()
            GenericTextField(value: $userAuthentification.email, isCorrect: $isEmailCorrect, prompt: "Your Email", sfIcon: "envelope")
            SecureGenericTextField(value: $userAuthentification.password, prompt: "Your Password", isCorrect: $isPasswordCorrect)
            Spacer()
            Button(action: {
                login()
            }) {
                FullWidthCapsuleButtonLabel(title: "Login")
            }
            .buttonStyle(.plain)
            
            SignInWithAppleButton(.signIn) { request in
                withAnimation {
                    makingNetworkCall = true
                }
                let nonce = String.randomNonceString()
                signInWithAppleVM.updateNonce(nonce)
                request.requestedScopes = [.email, .fullName]
                request.nonce = String.sha256(nonce)
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    handleAppleSignInResponse(authorization)
                case .failure(let error):
                    alertErrorTitle = "Sign in with Apple Failed"
                    alertErrorDescription = error.localizedDescription
                    showErrorAlert = true
                    withAnimation {
                        makingNetworkCall = false
                    }
                }
            }
            .frame(minHeight: 44, maxHeight: 64)
            .clipShape(Capsule())
            // For Dark Mode
            .shadow(color: .white, radius: 2)
            .padding(.vertical)
            
            if makingNetworkCall {
                ProgressView()
                    .padding()
            }
            
            Button(action: {
                showSignUpSheet.toggle()
            }) {
                Text("Create an account")
                    .font(.headline)
                    .padding()
            }
            .padding()
            Spacer()
        }
        .padding()
        .disabled(makingNetworkCall)
        .navigationTitle("Login")
        .sheet(isPresented: $showSignUpSheet) {
            SignUpView(
                userAuthentification: userAuthentification
            )
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(alertErrorTitle),
                message: Text(alertErrorDescription),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
    
    private func login() {
        withAnimation {
            makingNetworkCall = true
            isEmailCorrect = validator.validateEmail(userAuthentification.email)
            isPasswordCorrect = validator.validatePassword(userAuthentification.password)
        }
        if isEmailCorrect == true && isPasswordCorrect == true {
            userAuthentification.signIn { result, error in
                if let error = error {
                    alertErrorTitle = error.title
                    alertErrorDescription = error.localizedDescription
                    showErrorAlert.toggle()
                } else {
                    alertErrorTitle = "You are now signed in"
                    alertErrorDescription = "Hello \(result?.user.displayName ?? "!") !"
                    showErrorAlert.toggle()
                }
                withAnimation {
                    makingNetworkCall = false
                }
            }
        } else {
            withAnimation {
                makingNetworkCall = false
            }
        }
    }
    
    private func handleAppleSignInResponse(_ authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential, let identityToken = credential.identityToken, let identityTokenString = String(data: identityToken, encoding: .utf8) {
            signInWithAppleVM.updateTokenString(identityTokenString)
            signInWithAppleVM.signInWithFirebase { result, error in
                if let error = error {
                    alertErrorTitle = error.title
                    alertErrorDescription = error.localizedDescription
                    showErrorAlert.toggle()
                } else {
                    alertErrorTitle = "You are now signed in"
                    alertErrorDescription = "Hello \(result?.user.displayName ?? "!") !"
                    showErrorAlert.toggle()
                    let user = User(uuid: result!.user.uid, displayName: result?.user.displayName, email: result?.user.email)
                    userAuthentification.setAppleUser(user: user)
                }
                withAnimation {
                    makingNetworkCall = false
                }
            }
        } else {
            alertErrorTitle = "Sign in with Apple Failed"
            alertErrorDescription = "Invalid Request: Unable to fetch identity token"
            showErrorAlert = true
            signInWithAppleVM.updateNonce("")
            signInWithAppleVM.updateTokenString("")
            withAnimation {
                makingNetworkCall = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(userAuthentification: .init())
        }
    }
}



