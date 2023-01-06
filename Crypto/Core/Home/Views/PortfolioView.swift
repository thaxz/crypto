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
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
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
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
