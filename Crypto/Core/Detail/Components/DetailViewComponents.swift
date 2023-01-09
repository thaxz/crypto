//
//  DetailViewComponents.swift
//  Crypto
//
//  Created by thaxz on 08/01/23.
//

import Foundation
import SwiftUI

extension DetailView {
    
    var overviewTitle: some View {
        Text("OverView")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(detailViewModel.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    var additionalTitle: some View {
        Text("Aditional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(detailViewModel.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    var navBarTrailingItem: some View {
        HStack {
            Text(detailViewModel.coin.symbol.uppercased())
                .font(.headline)
            .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: detailViewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    var descriptionSection: some View {
        ZStack{
            // se existir e não for vazia
            if let coinDescription = detailViewModel.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.vertical, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20){
            if let websiteString = detailViewModel.websiteURL,
               let url = URL(string: websiteString){
                Link("Website", destination: url)
            }
            
            if let redditString = detailViewModel.redditURL,
               let url = URL(string: redditString){
                Link("Reddit", destination: url)
            }
            
        } .accentColor(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
    }
    
    
}
