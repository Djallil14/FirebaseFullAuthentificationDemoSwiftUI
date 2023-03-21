//
//  FillWidthCapsuleButton.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-21.
//

import SwiftUI

struct FullWidthCapsuleButtonLabel: View {
    let title: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                
            Spacer()
        }
        .background(Color.accentColor)
        .clipShape(Capsule())
    }
}

struct FullWidthCapsuleButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        FullWidthCapsuleButtonLabel(title: "Login")
    }
}
