//
//  DetailView.swift
//  Crypto
//
//  Created by thaxz on 07/01/23.
//

import SwiftUI

struct DetailLoadingView: View{
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var detailViewModel: DetailViewModel
    
    init(coin: CoinModel) {
        // como para inicializar a VM precisa de uma coin, e aqui a coin está sendo criada ao mesmo tempo
        // aqui estou inicializando a VM com a mesma coin do init
        _detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("initializing detail view for \(coin.name)")
    }
    
    var body: some View {
        Text("Hello")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
