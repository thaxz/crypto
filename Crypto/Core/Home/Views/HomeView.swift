//
//  HomeView.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import SwiftUI

struct HomeView: View {
    
    // ir para a página de portfólio
    @State var showPortfolio: Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            
            VStack{
                homeHeader
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}


