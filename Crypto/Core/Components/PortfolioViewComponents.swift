//
//  PortfolioViewComponents.swift
//  Crypto
//
//  Created by thaxz on 06/01/23.
//

import Foundation
import SwiftUI

extension PortfolioView{
    
    // Logo list
    var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 10){
                // para cada coin
                ForEach(homeViewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn){
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            // quando clicar em uma coin, ela vai ficar com contorno verde
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.accent : Color.clear, lineWidth: 1))
                }
            }
            .frame(height: 120)
                .padding(.leading)
        }
    }
    
    // InputView
    var portofolioInputSection: some View{
        VStack(spacing: 20){
            HStack{
                Text("Current price of: \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex.: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value: ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
                
            }
        }.animation(.none)
            .padding()
            .font(.headline)
    }
    
    // Func to get the current value
    func getCurrentValue()-> Double{
        // se conseguir converter para double
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    // Func to save value
    func saveButtonPressed(){
        // verificando se temos uma moeda
        guard let coin = selectedCoin else {return}
        // salvando para o portfolio
        
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
    
    // Func to reset selected coin
    func removeSelectedCoin(){
        selectedCoin = nil
        homeViewModel.searchText = ""
    }
    
    // toolbar trailing icon
    var trailingNavBarButtons: some View {
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1 : 0)
            Button {
                
            } label: {
                Text("SAVE")
            }
            // se tiver uma moeda selecionada e tiver um input novo
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1 : 0
            )
        } .font(.headline)
    }
}
