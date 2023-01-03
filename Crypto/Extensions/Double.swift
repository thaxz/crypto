//
//  Double.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import Foundation

// Conversões de double
extension Double {
        
    // Converte um Double em uma moeda com 2 casas decimais
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        // formatter.locale = .current // default value
        // formatter.currencyCode = "usd" // mudando moeda
        // formatter.currencySymbol = "$" // mudando simbolo
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    // Converte um Double em uma moeda com 2-6 casas decimais
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    // retorna formatado em porcentagem
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
}
