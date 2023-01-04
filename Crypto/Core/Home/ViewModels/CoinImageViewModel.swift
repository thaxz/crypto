//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    // Pegando um coin para podemos pegar dele a url da imagem
    private let coin: CoinModel
    // Instanciando o dataService
    private let dataService: CoinImageService
    // Lugar para armazenar
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        // pegando a url da imagem aqui
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    // Pegando a imagem se inscrevendo para o publisher dela
    private func addSubscribers(){
        dataService.$image
            .sink { [weak self] (_) in
                // se receber a imagem, deixando o isLoading falso
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
        // Storando quando quiser cancelar
            .store(in: &cancellables)
    }
    
}
