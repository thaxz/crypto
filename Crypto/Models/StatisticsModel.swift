//
//  StatisticsModel.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation

struct StatisticsModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    // criando um init personalizado para caso não tenha percentageChange, já vir com um valor default
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
}
