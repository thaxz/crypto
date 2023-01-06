//
//  PortfolioView.swift
//  Crypto
//
//  Created by thaxz on 06/01/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State var selectedCoin: CoinModel? = nil
    @State var quantityText: String = ""
    @State var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $homeViewModel.searchText)
                    coinLogoList
                    // se tiver alguma coin selecionada
                    if selectedCoin != nil {
                        portofolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            })
            // observando se o texto ficar vazio, tirar o teclado
            .onChange(of: homeViewModel.searchText) { value in
                // se o texto ficar vazio
                if value == ""{
                    removeSelectedCoin()
                }
            }
        }
    }
    
    // Func to save value
     func saveButtonPressed(){
        // verificando se temos uma moeda
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else {return}
        
        // salvando para o portfolio
        homeViewModel.updatePortfolio(coin: coin, amount: amount)
        
        // mostrando o botão
        withAnimation(.easeIn){
            showCheckmark = true
            removeSelectedCoin()
        }
        // escondendo o teclado
        UIApplication.shared.endEditing()
        // escondendo o botão
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeIn){
                showCheckmark = false
            }
        }
    }
    
    // Func to get the current value
     func getCurrentValue()-> Double{
        // se conseguir converter para double
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
     func updateSelectedCoin(coin: CoinModel){
         selectedCoin = coin
         // pegando os holdings igual a quantidade que tá no portfolio
         if let portfolioCoin = homeViewModel.portifolioCoins.first(where: {$0.id == coin.id}),
            let amount = portfolioCoin.currentHoldings {
             // e colocando no textField
             quantityText = "\(amount)"
         } else {
             // mas se não tiver, é vazio mesmo
             quantityText = ""
         }
    }
    
    // Func to reset selected coin
     func removeSelectedCoin(){
        selectedCoin = nil
        homeViewModel.searchText = ""
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
