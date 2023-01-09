//
//  DetailViewModel.swift
//  Crypto
//
//  Created by thaxz on 07/01/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    // Data que vamos popular a detailView
    @Published var overviewStatistics: [StatisticsModel] = []
    @Published var additionalStatistics: [StatisticsModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscriber()
    }
    
    private func addSubscriber(){
        coinDetailService.$coinDetails
        // combinando com o da moeda (pra pegar o id e saber qual é)
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self](returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self](returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    // Função de transformar (map) a data que recebemos para o tipo que queremos
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel]){
        // como na detail vou pegar 2 dados diferentes, aqui to transformando em dois
        // configurando array da sessão de overview
        let overviewArray = createOverViewArray(coinModel: coinModel)
        // Configurando array da sessão de additional
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overviewArray, additionalArray)
    }
    
    // Função para criar o array de informações que irá popular a sessão de overview
    private func createOverViewArray(coinModel: CoinModel) -> [StatisticsModel]{
        // configurando o array da sessão de overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticsModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticsModel(title: "Volume", value: volume)
        // adicionando tudo nele
        let overviewArray: [StatisticsModel] = [ priceStat, marketCapStat, rankStat, volumeStat]
        return overviewArray
    }
    // Função para criar o array de informações que irá popular a sessão de adicionais
    private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticsModel]{
        // Configurando array da sessão de additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticsModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticsModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticsModel(title: "24h Low", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticsModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)
        //adicionando tudo nele
        let additionalArray: [StatisticsModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
        return additionalArray
    }
}
