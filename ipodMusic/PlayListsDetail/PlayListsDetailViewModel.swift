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
            let parsedTracks: [ParsedPlayList] = tracks.map { return (id: $0.id.rawValue, albumUrl: $0.artwork?.url(width: 600, height: 600), title: $0.title,  subTitle: $0.artistName, duration: Int($0.duration!), albumTitle: $0.albumTitle, albumImage: nil)}
            playListTracks.send(parsedTracks)
            SelectedTracks.shared.list = parsedTracks
        } catch {
            print("request failed")
        }
    }
    // 선택한 track을 queue의 첫번째로 보내고, 나머지 track들을 뒤로 보내서 Player Queue에 등록
    func setPlayerQueue(selectedTrackId: String) {
        guard let tracks = playListTracks.value else { return }
        let otherTracks = tracks.filter {
            $0.id != selectedTrackId
        }
        let otherTracksIds = otherTracks.map { $0.id }
        let parsedIds = [selectedTrackId] + otherTracksIds
        PlayerQueue.shared.setQueue(ids: parsedIds)
    }

}
