//
//  HapticManager.swift
//  Crypto
//
//  Created by thaxz on 06/01/23.
//

import Foundation
import SwiftUI

class HapticManager{
    static private let generator =  UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
}
