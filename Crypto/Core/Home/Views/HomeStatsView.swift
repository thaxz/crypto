//
//  HomeStatsView.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            // dispondo cada stat com os dados da vm
            ForEach(homeViewModel.statistcs) { stat in
                StatisticView(stat: stat)
                // dividindo igualmente em 3 (pq sei que escolhi 3 infos só)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        // mudando o alinhamento do frame dependendo da tela que está
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
