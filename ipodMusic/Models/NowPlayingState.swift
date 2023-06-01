//
//  NowPlayingState.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/06/01.
//

import UIKit

struct NowPlayingState: Codable {
    let nowPlayingSong: NowPlayingSong
    let currentPlayingTime: Int
}

struct NowPlayingSong: Codable {
    let id: String
    let albumUrl: URL?
    let title: String
    let subTitle: String
    let duration: Int?
    let albumTitle: String?
}
