//
//  AlbumsDetailViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/29.
//

import MusicKit
import Combine
import UIKit

final class AlbumsDetailViewModel {
    private let album: Album
    private var subscriptions = Set<AnyCancellable>()
    var tracksByAlbum = CurrentValueSubject<[ParsedPlayList]?, Never>(nil)
    init(album: Album) {
        self.album = album
    }
}

extension AlbumsDetailViewModel {
    func fetchTracksByAlbum() async {
        Spinner.showLoading()
        do {
            let album = try await album.with([.tracks])
            guard let tracks = album.tracks else { return }
            let parsedTracks: [ParsedPlayList] = tracks.map { return (id: $0.id.rawValue, albumUrl: $0.artwork?.url(width: 600, height: 600), title: $0.title,  subTitle: $0.artistName, duration: Int($0.duration!), albumTitle: $0.albumTitle, albumImage: nil)}
            tracksByAlbum.send(parsedTracks)
            SelectedTracks.shared.list = parsedTracks
        } catch {
            print("request failed")
        }
    }
    
    func setPlayerQueue(selectedTrackId: String) {
        guard let tracks = tracksByAlbum.value else { return }
        if tracks.count > 1 {
            let otherTracks = tracks.filter {
                $0.id != selectedTrackId
            }
            let otherTracksIds = otherTracks.map { $0.id }
            let parsedIds = [selectedTrackId] + otherTracksIds
            PlayerQueue.shared.setQueue(ids: parsedIds)
        } else {
            PlayerQueue.shared.setQueue(ids: [selectedTrackId])
        }
    }
}
