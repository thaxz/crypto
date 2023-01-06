//
//  MarketDataService.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation
import Combine

class MarketDataService {
    
    // algum subscriber da viewmodel será inscrito nessa publisher que vai pegar a resposta da API
    @Published var marketData: MarketDataModel? = nil
    // criando um cancellable pra storar esse publisher
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    // pegando as informações da api
    func getData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        // pegando a url usando o método combine e usando o networking manager
        marketDataSubscription = NetworkingManager.download(url: url)
        // decodificando
            .decode(type: GlobalData.self, decoder: JSONDecoder())
        // Vendo se deu certo (observando a completion)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                // como é apenas um get request, que não vai vir mais de 1 valor ao mesmo tempo
                // cancelando se vier
                self?.marketDataSubscription?.cancel()
            })
    }
}
