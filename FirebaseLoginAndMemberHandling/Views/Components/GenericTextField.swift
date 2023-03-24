//
//  GenericTextField.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI

struct GenericTextField: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var value: String
    @Binding var isCorrect: Bool?
    let prompt: String
    var backgroundColor: Color = .blue.opacity(0.05)
    var textColor: Color = .black
    var borderColor: Color = .black
    var lineWidth: CGFloat = 2
    var sfIcon: String = "person"
    var autoCorrectionDisabled: Bool = true
    var body: some View {
        VStack {
            HStack {
                Image(systemName: sfIcon)
                    .imageScale(.large)
                TextField(prompt, text: $value)
                    .foregroundColor(colorScheme == .light ? .black : .white)
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


struct GenericTextField_Previews: PreviewProvider {
    static var previews: some View {
        GenericTextField(value: .constant(""), isCorrect: .constant(nil), prompt: "Your Username")
    }
}
