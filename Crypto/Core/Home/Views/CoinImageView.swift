//
//  CoinImageView.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import SwiftUI


struct CoinImageView: View {
    
    @StateObject var coinImageViewModel: CoinImageViewModel
    
    init(coin: CoinModel){
        _coinImageViewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack{
            // checando se há imagem
            if let image = coinImageViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if coinImageViewModel.isLoading {
                // se estiver carregando
                ProgressView()
            } else {
                // se não conseguiu
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
