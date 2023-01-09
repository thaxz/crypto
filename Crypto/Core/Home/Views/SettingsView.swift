//
//  SettingsView.swift
//  Crypto
//
//  Created by thaxz on 09/01/23.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL: URL = URL(string: "https://www.google.com")!
    let personalURL: URL = URL(string: "https://www.behance.net/thaxz/")!
    let coingeckoURL: URL = URL(string: "https://www.coingecko.com")!
    
    var body: some View {
        NavigationView{
            VStack {
                List{
                    courseSection
                    apiSection
                    linksSection
                }
                .tint(.blue)
                Spacer()
            }
            
        .navigationTitle("Settings")
        .listStyle(GroupedListStyle())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SettingsView()
        }
    }
}

