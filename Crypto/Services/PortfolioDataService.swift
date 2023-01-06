//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by thaxz on 06/01/23.
//

import Foundation
import CoreData

// gerencia a lógica de pegar as coisas do coreData
class PortfolioDataService {
    
    // Passando o container criado no arquivo .xdatamodel
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    // Data que vai retornar se o request for bem sucedido
    // Vai funcionar da mesma forma que o "allCoins" etc
    @Published var savedEntities: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error loading core data! \(error)")
            }
            // pegando o portfolio
            self.getPortfolio()
        }
    }
    
    // MARK: Public
    // função que poderemos chamar de qualquer lugar
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        // Checando se já tem essa moeda no portfolio
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}){
            // Checando se estamos mudando o amount
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                // ou deletando
                delete(entity: entity)
            }
        } else {
            // se não tivermos essa moeda, vai ser nova, então add
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: Private section
    // funções privadas para o funcionamento do coreData
    
    // função para pegar o que está dentro do coreData
    private func getPortfolio(){
        // criando fetchRequest
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio request \(error)")
        }
    }
    
    // função para adicionar ao coreData
    private func add(coin: CoinModel, amount: Double){
        // pegando a entidade
        let entity = PortfolioEntity(context: container.viewContext)
        // preenchendo as propriedades dela
        entity.coinID = coin.id
        entity.amount = amount
        // salvando no context
        applyChanges()
    }
    
    // funcão para dar update da entidade
    func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    // Função para deletar
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    // função para salvar no coreData
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data \(error)")
        }
    }
    
    // Função para aplicar as mudanças pro array
    private func applyChanges(){
        save()
        getPortfolio()
    }
}
