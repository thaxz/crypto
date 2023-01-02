//
//  CircleButtonView.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import SwiftUI

struct CircleButtonView: View {
    // como é um componente, deixando o nome customizável
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 5, x: 0, y: 0)
            .padding()
        
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "info")
            .previewLayout(.sizeThatFits)
    }
}
