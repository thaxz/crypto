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
    
    // Instanciando o singleton do fileManager para checar se já temos as imagens
    private let fileManager = LocalFileManager.shared
    
    // nome da pasta que as imagens serão salvas
    private let folderName = "coin_images"
    private let imageName: String
    
    // Inicializando pedindo a coin
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Retrieved image from file manager!")
        } else {
            // se já não estiver baixada
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage(){
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
                guard let self = self, let downloadedImage = returnedImage else {return}
                self.image = downloadedImage
                // como é apenas um get request, que não vai vir mais de 1 valor ao mesmo tempo
                // cancelando se vier
                self.imageSubscription?.cancel()
                // salvando imagens no FM
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
}
