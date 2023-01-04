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
    // acessando a viewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            
            VStack{
                homeHeader
                
                SearchBarView(searchText: $homeViewModel.searchText)
                
                columnTitles
                
                // se estiver falso, mostrar a lista com todas moedas
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
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
        .environmentObject(dev.homeVM)
    }
}


