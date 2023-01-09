//
//  LaunchView.swift
//  Crypto
//
//  Created by thaxz on 09/01/23.
//

import SwiftUI

struct LaunchView: View {
    
    // transformando uma string em um array de characters
    @State private var loadingText: [String] = "Loading your portfolio...".map {String($0)}
    // criando um timer
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    // variávris para ver os números
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    // variáveis para controlar quando vai aparecer/parar
    @State private var showLoadingText: Bool = false
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack{
            Color("LaunchBackgroundColor")
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack{
                if showLoadingText {
                    // quando for true, colocar cada letra na tela com esse offset qnd chega o index
                    HStack(spacing: 0){
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color("LaunchAccentColor"))
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                }
            }
            .offset(y: 70)
        }
        .onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()){
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
