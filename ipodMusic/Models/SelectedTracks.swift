//
//  SelectedTracks.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/23.
//

import Foundation

final class SelectedTracks {
    static let shared = SelectedTracks()
    private init() {}
    var list: [ParsedPlayList] = []
}
