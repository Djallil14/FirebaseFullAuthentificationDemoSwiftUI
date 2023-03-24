//
//  SmallCloseButtonLabel.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-24.
//

import SwiftUI

struct SmallCloseButtonLabel: View {
    var body: some View {
        Image(systemName: "xmark")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .clipShape(Circle())
    }
}

struct SmallCloseButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        SmallCloseButtonLabel()
    }
}
