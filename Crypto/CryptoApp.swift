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
    // Para dar dismiss na launchView
    @State private var showLaunchView: Bool = true
    
    // colocando cor customizada nos navigationTitles
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear 
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                // todas as children dessa navigation poderão acessar
                .environmentObject(homeViewModel)
                // Para rodar direito no ipad
                .navigationViewStyle(StackNavigationViewStyle())
                
                ZStack{
                    if showLaunchView {
                        // launchscreen fake
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                } .zIndex(2)
            }
        }
    }
}
