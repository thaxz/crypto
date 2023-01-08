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
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let spacing: CGFloat = 20
    
    init(coin: CoinModel) {
        // como para inicializar a VM precisa de uma coin, e aqui a coin está sendo criada ao mesmo tempo
        // aqui estou inicializando a VM com a mesma coin do init
        _detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 20){
                ChartView(coin: detailViewModel.coin)
                    .padding(.vertical)
                overviewTitle
                Divider()
                overviewGrid
                
                additionalTitle
                Divider()
                additionalGrid
            }
            .padding()
        }
        .navigationTitle(detailViewModel.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                navBarTrailingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
    }
}
