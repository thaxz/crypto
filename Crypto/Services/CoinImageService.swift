//
//  CoinImageServices.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    
    // Inicializando pedindo a coin
    init(coin: CoinModel){
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage(){
        // pegando a url da coin
        guard let url = URL(string: coin.image) else {return}
        // pegando a url usando o método combine
        imageSubscription = NetworkingManager.download(url: url)
        // Transformando
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
        // Vendo se deu certo (observando a completion)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
                // como é apenas um get request, que não vai vir mais de 1 valor ao mesmo tempo
                // cancelando se vier
                self?.imageSubscription?.cancel()
            })
    }
    
}
