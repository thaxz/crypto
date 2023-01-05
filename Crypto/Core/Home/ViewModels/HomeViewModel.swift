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
    
    // estatísticas
    @Published var statistcs: [StatisticsModel] = []
    
    // Todas moedas
    @Published var allCoins: [CoinModel] = []
    // Moedas que o user tem
    @Published var portifolioCoins: [CoinModel] = []
    // para pegar o texto do textfield
    @Published var searchText: String = ""
    
    // Chamando a classe que tá baixando a data
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    // criando o lugar para storar
    private var cancellabes = Set<AnyCancellable>()
    
    init(){
      addSubscribers()
    }
    
    // Pegando a data atualizada e passando para cá
    func addSubscribers(){
        // me inscrevendo para receber updates do que está sendo colocado no textField
        $searchText
        // combinando dois subscribers para receber updates nos dois
            .combineLatest(coinDataService.$allCoins)
        // colocando um delay para caso o user digite rápido
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        // transformando o resultado em um array filtrado
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellabes)
        
        // cadastrando no outro subscriber que pega outro request
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistcs = returnedStats
            }
            .store(in: &cancellabes)
    }
    
    // Função para filtrar usando a searchBar
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        // se o txtfld estiver vazio, não precisa filtrar, só retorna
        guard !text.isEmpty else { return coins }
        // convertendo tudo pra ter melhores resultados
        let lowercasedText = text.lowercased()
        // filtrando
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    // Função para fazer o map do globalMarketData
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        // vendo se tem data
        guard let data = marketDataModel else {return stats}
        // se tiver, convertendo e preenchendo
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticsModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}
