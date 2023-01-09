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
    // Se a terra estiver carregando
    @Published var isLoading: Bool = false
    // Que tipo de sort o user vai escolher
    @Published var sortOption: SortOption = .holdings
    
    // Chamando as classes que estão atualizando os publishers
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    // criando o lugar para storar
    private var cancellabes = Set<AnyCancellable>()
    
    // Enum para sort as informações
    enum SortOption{
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init(){
      addAllSubscribers()
    }
    
    // Pegando as datas atualizadas e passando para cá
    func addAllSubscribers(){
        isLoading = true
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
            .combineLatest(coinDataService.$allCoins, $sortOption)
        // colocando um delay para caso o user digite rápido
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        // transformando o resultado em um array filtrado
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellabes)
    }
    // Se inscrevendo no subscriber de marketData
    func addMarketDataSubscriber(){
        // cadastrando no outro subscriber que pega marketData
        marketDataService.$marketData
        // combinando com o do portfolio, para ter o valor atualizado
            .combineLatest($portifolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistcs = returnedStats
                self?.isLoading = false
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
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else {return}
                self.portifolioCoins = self.sortPortfolioCoinsIfNeedeed(coins: returnedCoins)
            }
            .store(in: &cancellabes)
    }
    
    // Função para chamarmos na view e darmos update no coreData
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    // Função para dar reload na data
    func reloadData(){
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    // Função para filtrar e ordenar
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel]{
        // filtrando
        var updatedCoins = filterCoins(text: text, coins: coins)
        // ordenando
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
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
    
    // Filtrando as do portfolio (por holdings)
    private func sortPortfolioCoinsIfNeedeed(coins: [CoinModel])-> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    // Função para ordenar
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort {
        case .rank, .holdings:
             coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
             coins.sort(by: {$0.rank > $1.rank})
        case .price:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
            }
        }
    
    
    // Função para transformar as moedas em portfolioCoins e salvar no coreData
    func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], porfolioEntities: [PortfolioEntity]) -> [CoinModel]{
        allCoins
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
    
    // Função para fazer o map do globalMarketData
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        // vendo se tem data
        guard let data = marketDataModel else {return stats}
        
        // se tiver, convertendo e preenchendo
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        
        // pegando o valor que temos no portfolio e somando todos
        let portfolioValue =
        portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        // calculando a % que as moedas do portfolio subiram
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        } .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) 
            
        let portfolio = StatisticsModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}
