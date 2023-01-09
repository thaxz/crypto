//
//  ChartViewComponents.swift
//  Crypto
//
//  Created by thaxz on 09/01/23.
//

import Foundation
import SwiftUI

extension ChartView {
    
    // Chart
     var chartView: some View {
        // criando a linha do gráfico
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    //posição do eixo x que vai aumentando a cada index
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index * 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor,
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 5, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 5, x: 0, y: 20)
            //.shadow(color: lineColor.opacity(0.2), radius: 5, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 5, x: 0, y: 40)
        }
    }
    
    // grid do chart
    var chartBackground: some View{
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    // numeros chart
    var chartYAxis: some View {
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    var chartDateLabels: some View {
        HStack{
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
}

