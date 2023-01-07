//
//  DetailViewModel.swift
//  Crypto
//
//  Created by thaxz on 07/01/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: CoinModel){
        self.coinDetailService = CoinDetailDataService(coin: coin)
    }
    
    private func addSubscriber(){
        coinDetailService.$coinDetails
            .sink { (returnedCoinsDetails) in
                print("recieved coin detail data")
                print(returnedCoinsDetails)
            }
            .store(in: &cancellables)
    }
    
    
    
    
    
    
    
}
