//
//  HomeViewModel.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import Foundation
import Combine

/*
como essa viewModel (as moedas) vão ser usadas em vários lugares
vou colocar no enviroment, para ser acessada de qlr lugar fácil
*/
class HomeViewModel: ObservableObject {
    
    // estatísticas
    @Published var statistcs: [StatisticsModel] = []
    
    // Todas moedas
    @Published var allCoins: [CoinModel] = []
    // Moedas que o user tem
    @Published var portifolioCoins: [CoinModel] = []
    // para pegar o texto do textfield
    @Published var searchText: String = ""
    
    // Chamando as classes que estão atualizando os publishers
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    // criando o lugar para storar
    private var cancellabes = Set<AnyCancellable>()
    
    init(){
      addAllSubscribers()
    }
    
    // Pegando as datas atualizadas e passando para cá
    func addAllSubscribers(){
        addAllCoinsSubscriber()
        addMarketDataSubscriber()
        addPortfolioSubscriber()
    }
    
    // Se inscrevendo no subscriber de allCoins
    func addAllCoinsSubscriber(){
        // cadastrando no subscriber de allCoins
        $searchText
        // me inscrevendo para receber updates do que está sendo colocado no textField
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
    }
    // Se inscrevendo no subscriber de marketData
    func addMarketDataSubscriber(){
        // cadastrando no outro subscriber que pega marketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistcs = returnedStats
            }
            .store(in: &cancellabes)
    }
    // Se inscrevendo no subscriber de portfolio
    func addPortfolioSubscriber(){
        // cadastrando no subscriber de portfolio
        $allCoins
        // mas combinando ele com as coins filtradas já, o outro subscriber
            .combineLatest(portfolioDataService.$savedEntities)
        // convertendo em um array de portfolioCoins
            .map { (coinModels, porfolioEntities) -> [CoinModel] in
                coinModels
                // map compacto pq teremos optionals, as moedas que não serão usadas
                    .compactMap { (coin) -> CoinModel? in
                        // Se tiver no portfolio
                        guard let entity = porfolioEntities.first(where: {$0.coinID == coin.id}) else {
                            // se não tiver, retorna nulo.
                            return nil
                        }
                        //se tiver, retorna ela com o amount atualizado
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                self?.portifolioCoins = returnedCoins
            }
            .store(in: &cancellabes)
    }
    
    // Função para chamarmos na view e darmos update no coreData
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
