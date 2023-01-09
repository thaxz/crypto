//
//  SettingsViewComponents.swift
//  Crypto
//
//  Created by thaxz on 09/01/23.
//

import Foundation
import SwiftUI

extension SettingsView{
    
    var courseSection: some View {
        Section {
            HStack( spacing: 20) {
                Text("This conforms to MVVM Architecture, using Combine and CoreDara. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publihsers/subscribers, and data persistance.")
                    .font(.callout)
                    .foregroundColor(Color.theme.accent)
                
            }
            .multilineTextAlignment(.leading)
            .padding(.vertical)
            Link("Visit project page", destination: personalURL)
        } header: {
            HStack{
                Image("logo")
                    .resizable()
                .frame(width: 20, height: 20)
                Text("About")
            }
        }
    }
    
    var apiSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                .frame(height: 100)
                Text("The cryptocurrency data that is used in this apps comes from a free API from Coingecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Coingecko", destination: coingeckoURL)
        } header: {
            Text("CoinGecko")
        }
    }
    
    var linksSection: some View{
        Section {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn more", destination: defaultURL)
        } header: {
            Text("Links")
        }
    }
}
