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
    @State var isUsernameCorrect: Bool?
    @State var isEmailCorrect: Bool?
    @State var isPasswordCorrect: Bool?
    @State var makingNetworkCall: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()
            Spacer()
            GenericTextField(value: $userAuthentification.displayName, isCorrect: $isUsernameCorrect, prompt: "Your Display Name")
            GenericTextField(value: $userAuthentification.email, isCorrect: $isEmailCorrect, prompt: "Your Email", sfIcon: "envelope")
            SecureGenericTextField(value: $userAuthentification.password, prompt: "Your Password", isCorrect: $isPasswordCorrect)
            SecureGenericTextField(value: $userAuthentification.passwordConfirmation, prompt: "Password Confirmation", sfIcon: "lock.fill", isCorrect: $isPasswordCorrect)
            Spacer()
            Button(action: {
                withAnimation {
                    makingNetworkCall = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // Sign up
                    withAnimation {
                        isUsernameCorrect = Bool.random()
                        isEmailCorrect = Bool.random()
                        isPasswordCorrect = Bool.random()
                        makingNetworkCall = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                FullWidthCapsuleButtonLabel(title: "Sign Up")
            }
            if makingNetworkCall {
                ProgressView()
            }
            Spacer()
        }
        .disabled(makingNetworkCall)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView(userAuthentification: .init())
        }
    }
}
