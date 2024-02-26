//
//  Tab.swift
//  SwiftUI YouTube Mini Player
//
//  Created by Hamed Majdi on 2/24/24.
//

import SwiftUI

enum Tab: String, CaseIterable{
    case home = "Home"
    case short = "Shorts"
    case subscrptions = "Subscriptions"
    case you = "You"
    
    var symbol: String {
        switch self {
        case .home:
            return "house.fill"
        case .short:
            return "video.badge.waveform.fill"
        case .subscrptions:
            return "play.square.stack.fill"
        case .you:
            return "person.circle.fill"
        }
    }
}
