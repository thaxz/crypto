//
//  ContentView.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
            
            VStack(spacing: 40){
                Text("1")
                    .foregroundColor(Color.theme.red)
                Text("1")
                    .foregroundColor(Color.theme.green)
                Text("1")
                    .foregroundColor(Color.theme.accent)
                Text("1")
                    .foregroundColor(Color.theme.secondaryText)
            } .font(.headline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
