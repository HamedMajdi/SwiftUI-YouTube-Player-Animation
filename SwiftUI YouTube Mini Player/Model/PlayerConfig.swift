//
//  PlayerConfig.swift
//  SwiftUI YouTube Mini Player
//
//  Created by Hamed Majdi on 2/26/24.
//

import SwiftUI

struct PlayerConfig: Equatable {
 
    var position: CGFloat = .zero
    var lastPosision: CGFloat = .zero
    var progress: CGFloat = .zero
    var selectePlayerItem : PlayerItem?
    var showMiniPlayer: Bool = false
    
    mutating func resetPosition(){
        position = .zero
        lastPosision = .zero
        progress = .zero
    }
}
