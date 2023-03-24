//
//  ProfilButtonLabel.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-23.
//

import SwiftUI

struct ProfilButtonLabel: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let icon: String
    var backgroundColor: Color = .accentColor
    var textColor: Color = .white
    var borderColor: Color = .black
    var lineWidth: CGFloat = 2
    var cornerRadius: CGFloat = 12
    var isFullWidth: Bool = true
    var body: some View {
        HStack {
            if isFullWidth {
                Spacer()
            }
            Image(systemName: icon)
            Text(title)
                .font(.headline)
            if isFullWidth {
                Spacer()
            }
        }
        .foregroundColor(textColor)
        .padding()
        .background(backgroundColor)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: lineWidth)
                .fill(colorScheme == .light ? borderColor : .white)
        )
        .cornerRadius(cornerRadius)
    }
}

struct ProfilButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        ProfilButtonLabel(title: "Change Email", icon: "envelope")
    }
}
