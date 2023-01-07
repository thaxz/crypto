//
//  String.swift
//  Crypto
//
//  Created by thaxz on 07/01/23.
//

import Foundation

extension String {
    
    // Função para remover
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
