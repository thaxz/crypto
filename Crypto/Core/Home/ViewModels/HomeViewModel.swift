//
//  HomeViewModel.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import Foundation


class HomeViewModel: ObservableObject {
    
    /*
    como essa viewModel (as moedas) vão ser usadas em vários lugares
    vou colocar no enviroment, para ser acessada de qlr lugar fácil
    */
    
    // Todas moedas
    @Published var allCoins: [CoinModel] = []
    // Moedas que o user tem
    @Published var portifolioCoins: [CoinModel] = []
    
    // Fingindo que to baixando da internet
    init(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(DeveloperPreview.shared.coin)
            self.portifolioCoins.append(DeveloperPreview.shared.coin)
        }
        
        
        
    }
    
    
}
