//
//  HomeViewComponents.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import Foundation
import SwiftUI

extension HomeView {
    
    // header component
    var homeHeader: some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .background(
                    //colocando animação binding com showPortfolio
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            
            Text(showPortfolio ? "Porfolio" : "Live Prices")
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
            // definindo a rotacão de acordo com o lugar que estiver
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
            // quando tocar nele
                .onTapGesture {
                    withAnimation(.spring()){
                        // mudando o valor da state
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    
    
}
