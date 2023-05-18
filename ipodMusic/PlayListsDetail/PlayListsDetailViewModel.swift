//
//  PlayListsDetailViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/18.
//

import Foundation
import MusicKit
import Combine

final class PlayListsDetailViewModel {
    var playList: Playlist
    private var subscriptions = Set<AnyCancellable>()
    var playListTracks = CurrentValueSubject<[ParsedPlayList]?, Never>(nil)
    init(with playList: Playlist) {
        self.playList = playList
    }
}

extension PlayListsDetailViewModel {
    func fetchPlayListTracks() async {
        Spinner.showLoading()
        do {
            let detailedLibraryPlaylist = try await playList.with([.tracks])
            guard let tracks = detailedLibraryPlaylist.tracks else { return }
            let parsedTracks: [ParsedPlayList] = tracks.map { return (id: $0.id, albumUrl: $0.artwork?.url(width: 60, height: 60), title: $0.title,  subTitle: $0.artistName)}
            playListTracks.send(parsedTracks)
        } catch {
            print("request failed")
        }
    }
}
