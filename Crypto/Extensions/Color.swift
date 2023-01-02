//
//  Color.swift
//  Crypto
//
//  Created by thaxz on 02/01/23.
//

import Foundation
import SwiftUI

extension Color {
    // toda vez que acessar "Color", conseguiremos acessar as cores que cadastramos
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    
}
