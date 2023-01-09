//
//  HomeView.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import SwiftUI

struct HomeView: View {
    
    // ir para a página de portfólio (animar p/ o lado)
    @State var showPortfolio: Bool = false
    // novas sheets aparecendo
    @State var showPortfolioView: Bool = false
    @State var showSettingsView: Bool = false
    // acessando a viewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    // para ir para a detailView
    @State var selectedCoin: CoinModel? = nil
    @State var showDetailView: Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            // Sheet do portfolio
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(homeViewModel)
                }
            
            VStack{
                homeHeader
                // estatísticas
                HomeStatsView(showPortfolio: $showPortfolio)
                // searchBar
                SearchBarView(searchText: $homeViewModel.searchText)
                // nomes em cima das colunas
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
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(
                            destination: DetailLoadingView(coin: $selectedCoin),
                            isActive: $showDetailView,
                            // não vamos clicar então empty
                            label: { EmptyView() })
        )
    }
    
    func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
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


