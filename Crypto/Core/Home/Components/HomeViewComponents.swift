//
//  HomeViewComponents.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import Foundation
import SwiftUI

extension HomeView {
    
    // header component
    var homeHeader: some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                // Para ir para a view correspondente da tela que está
                .onTapGesture {
                    // se estiver na de portfolio
                    if showPortfolio {
                        // mudando o valor para aparecer a sheet
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    //colocando animação binding com showPortfolio
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            
            Text(showPortfolio ? "Porfolio" : "Live Prices")
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
            // definindo a rotacão de acordo com o lugar que estiver
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
            // quando tocar nele
                .onTapGesture {
                    withAnimation(.spring()){
                        // mudando o valor da state
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
   
    // all coins list component
    var allCoinsList: some View{
        List{
            ForEach(homeViewModel.allCoins) { coin in
                // Para cada moeda nessa lista, preenche a row e leva para a tela de detalhe
                CoinRowView(coin: coin, showHoldingsColumn: false)
                // arrumando o padding
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }.listStyle(PlainListStyle())
    }
    // portfolio coins list component
    var portfolioCoinsList: some View{
        List{
            ForEach(homeViewModel.portifolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                // arrumando o padding
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }.listStyle(PlainListStyle())
    }
    // titles de cada coluna
    var columnTitles: some View {
        // Stack do coin que quando clica ordena
        HStack{
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((homeViewModel.sortOption == .rank || homeViewModel.sortOption == .rankReversed)  ? 1 : 0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .rank ? 0 : 180))
            }
            // quando tocar
            .onTapGesture {
                withAnimation(.default){
                    // se estiver ordenado pelo um jeito, muda pro outro
                    homeViewModel.sortOption = homeViewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            
            // Stack dos holdings que quando clica ordena
            if showPortfolio {
                HStack(spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((homeViewModel.sortOption == .holdings || homeViewModel.sortOption == .holdingsReversed)  ? 1 : 0)
                        .rotationEffect(Angle(degrees: homeViewModel.sortOption == .holdings ? 0 : 180))
                }
                // quando tocar
                .onTapGesture {
                    withAnimation(.default){
                        // se estiver ordenado pelo um jeito, muda pro outro
                        homeViewModel.sortOption = homeViewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            // Stack do price que quando clica ordena
            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((homeViewModel.sortOption == .price || homeViewModel.sortOption == .priceReversed)  ? 1 : 0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .price ? 0 : 180))
            }
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            // quando tocar
            .onTapGesture {
                withAnimation(.default){
                    // se estiver ordenado pelo um jeito, muda pro outro
                    homeViewModel.sortOption = homeViewModel.sortOption == .price ? .priceReversed : .price
                }
            }
            
            // botão para atualizar os dados
            Button {
                withAnimation(.linear(duration: 2.0)){
                    homeViewModel.reloadData()
                }
            } label: {
                Image(systemName: "gofoward")
            } .rotationEffect(Angle(degrees: homeViewModel.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}
