//
//  ChangeDisplayName.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-24.
//

import SwiftUI

struct ChangeDisplayNameView: View {
    @ObservedObject var userAuthentification: UserAuthentification
    @Environment(\.presentationMode) var presentationMode
    @State private var displayName: String = ""
    @State private var isNameValid: Bool?
    @State private var nameDidChange: Bool = false
    @State private var isMakingNetworkCall = false
    @State private var errorTitle: String?
    @State private var errorDescription: String?
    private let validator = Validator.shared

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Change Display Name")
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
            GenericTextField(value: $displayName, isCorrect: $isNameValid, prompt: "Enter your new display name")
            Button {
                changeName()
            } label: {
                FullWidthCapsuleButtonLabel(title: "Change Display Name")
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
        if nameDidChange {
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
    
    private func changeName() {
        isNameValid = validator.validateName(displayName)
        if isNameValid == true {
            isMakingNetworkCall = true
            userAuthentification.changeDisplayName(displayName: displayName) { error in
                if let error = error {
                    errorTitle = error.title
                    errorDescription = error.localizedDescription
                    withAnimation {
                        isMakingNetworkCall = false
                    }
                } else {
                    withAnimation {
                        nameDidChange = true
                        isMakingNetworkCall = false
                    }
                }
            }
        }
    }
}

struct ChangeDisplayNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeDisplayNameView(userAuthentification: .init())
    }
}
