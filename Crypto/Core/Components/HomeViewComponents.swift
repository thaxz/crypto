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
                CoinRowView(coin: coin, showHoldingsColumn: false)
                // arrumando o padding
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
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
            }
        }.listStyle(PlainListStyle())
    }
    // titles de cada coluna
    var columnTitles: some View {
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
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
