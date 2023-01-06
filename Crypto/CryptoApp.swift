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
    
    // colocando cor customizada nos navigationTitles
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
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
