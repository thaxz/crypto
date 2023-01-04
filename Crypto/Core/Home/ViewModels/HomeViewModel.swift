//
//  HomeViewModel.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    
    /*
    como essa viewModel (as moedas) vão ser usadas em vários lugares
    vou colocar no enviroment, para ser acessada de qlr lugar fácil
    */
    
    // Todas moedas
    @Published var allCoins: [CoinModel] = []
    // Moedas que o user tem
    @Published var portifolioCoins: [CoinModel] = []
    
    // Chamando a classe que tá baixando a data
    private let dataService = CoinDataService()
    // criando o lugar para storar
    private var cancellabes = Set<AnyCancellable>()
    
    init(){
      addSubscribers()
    }
    
    // Pegando a data atualizada e passando para cá
    func addSubscribers(){
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellabes)
    }
    
    
}
