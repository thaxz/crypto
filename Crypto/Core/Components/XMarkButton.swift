//
//  XMarkButton.swift
//  Crypto
//
//  Created by thaxz on 06/01/23.
//

import SwiftUI

struct XMarkButton: View {
    
    // para poder dar dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
