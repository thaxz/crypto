//
//  UIApplication.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation
import SwiftUI

// Extendendo para gerenciar o teclado saindo da tela
extension UIApplication {
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
