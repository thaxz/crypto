//
//  CoinRowView.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import SwiftUI

struct CoinRowView: View {
    // View da lista das moedas
    let coin: CoinModel
    // se deve apaerecer a coluna do meio
    let showHoldingsColumn: Bool
    
    var body: some View {
        
        HStack(spacing: 0){
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .contentShape(Rectangle())
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingsColumn: true)
    }
}
