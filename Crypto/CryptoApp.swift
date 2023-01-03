//
//  CryptoApp.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    // Para acessar de qualquer lugar
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            // todas as children dessa navigation poderão acessar
            .environmentObject(homeViewModel)
        }
    }
}
