//
//  SecureGenericTextField.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI

struct SecureGenericTextField: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var value: String
    let prompt: String
    var backgroundColor: Color = .blue.opacity(0.05)
    var textColor: Color = .black
    var borderColor: Color = .black
    var lineWidth: CGFloat = 2
    var sfIcon: String = "lock"
    var autoCorrectionDisabled: Bool = true
    @Binding var isCorrect: Bool?
    var body: some View {
        HStack {
            Image(systemName: sfIcon)
                .imageScale(.large)
            SecureField(prompt, text: $value)
                .foregroundColor(textColor)
                .autocorrectionDisabled(autoCorrectionDisabled)
            confirmationOrErrorLogo()
        }
        .padding()
        .background(backgroundColor)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: lineWidth)
                .fill(colorScheme == .light ? borderColor : .white)
        )
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func confirmationOrErrorLogo() -> some View {
        if let isCorrect = isCorrect {
            if isCorrect {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "xmark")
                    .foregroundColor(.red)
            }
        }
    }
}

struct SecureGenericTextField_Previews: PreviewProvider {
    static var previews: some View {
        SecureGenericTextField(value: .constant(""), prompt: "Your Password", isCorrect: .constant(nil))
    }
}
