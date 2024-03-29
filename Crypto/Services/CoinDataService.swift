//
//  CoinDataService.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation
import Combine

class CoinDataService {
    
    // algum subscriber da viewmodel será inscrito nessa publisher que vai pegar a resposta da API
    @Published var allCoins: [CoinModel] = []
    // criando um cancellable pra storar esse publisher
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    
    func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        // pegando a url usando o método combine e usando o networking manager
        coinSubscription = NetworkingManager.download(url: url)
        // decodificando
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
        // Vendo se deu certo (observando a completion)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                // como é apenas um get request, que não vai vir mais de 1 valor ao mesmo tempo
                // cancelando se vier
                self?.coinSubscription?.cancel()
            })
    }
}
