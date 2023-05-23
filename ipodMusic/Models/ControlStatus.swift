//
//  ControlStatus.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/23.
//

import Foundation

final class ControlStatus {
    static let shared = ControlStatus()
    private init() {}
    enum RepeatStatus {
        case repeatOff, repeatOn, repeatOne
    }
    enum ShuffleStatus {
        case shuffleOff, shuffleOn
    }
    var repeatMode: RepeatStatus = .repeatOff
    var shuffleMode: ShuffleStatus = .shuffleOff
}
