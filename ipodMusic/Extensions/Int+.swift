//
//  Int+.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/22.
//

import Foundation

extension Int {
    func secondsToText() -> String {
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
