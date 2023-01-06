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
    
    init(){
        container = NSPersistentContainer(name: containerName)
    }
    
    
    
    
}
