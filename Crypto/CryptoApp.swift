//
//  CryptoApp.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import SwiftUI

@main
struct CryptoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
