//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by thaxz on 07/01/23.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    // algum subscriber da viewmodel será inscrito nessa publisher que vai pegar a resposta da API
    @Published var coinDetails: CoinDetailModel? = nil
    // criando um cancellable pra storar esse publisher
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }
    
    
    func getCoinsDetails(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        // pegando a url usando o método combine e usando o networking manager
        coinDetailSubscription = NetworkingManager.download(url: url)
        // decodificando
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
        // Vendo se deu certo (observando a completion)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinsDetails) in
                self?.coinDetails = returnedCoinsDetails
                // como é apenas um get request, que não vai vir mais de 1 valor ao mesmo tempo
                // cancelando se vier
                self?.coinDetailSubscription?.cancel()
            })
    }
}


