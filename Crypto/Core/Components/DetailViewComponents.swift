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
    
    
    
    
    
    
}
