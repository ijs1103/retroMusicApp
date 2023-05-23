//
//  PlayingStatus.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/24.
//

import Foundation

final class PlayingStatus {
    static let shared = PlayingStatus()
    private init() {}
    enum PlayingMode {
        case playing, paused, stopped
    }
    var playingMode: PlayingMode = .stopped
}
