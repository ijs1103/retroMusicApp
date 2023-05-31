//
//  SearchResultArtistsDetailDetailViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/31.
//

import MusicKit
import Combine
import UIKit

final class SearchResultArtistsDetailDetailViewModel {
    private let albumId: String
    private let album: Album
    private var subscriptions = Set<AnyCancellable>()
    var tracks = CurrentValueSubject<[ParsedPlayList]?, Never>(nil)
    init(albumId: String, originalAlbum: Album) {
        self.albumId = albumId
        self.album = originalAlbum
    }
}

extension SearchResultArtistsDetailDetailViewModel {
    func fetchTracks() async {
        Spinner.showLoading()

        let url = URL(string: "https://api.music.apple.com/v1/catalog/us/albums/\(albumId)/tracks")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        do {
            let response = try await request.response()
            let decoded = try JSONDecoder().decode(MusicItemCollection<Song>.self, from: response.data)
            let parsed: [ParsedPlayList] = decoded.map { return (id: $0.id.rawValue, albumUrl: $0.artwork?.url(width: 600, height: 600), title: $0.title,  subTitle: $0.artistName, duration: Int($0.duration!), albumTitle: $0.albumTitle, albumImage: nil)}
            tracks.send(parsed)
            SelectedTracks.shared.list = parsed
        } catch {
            print("request failed")
        }
    }
    func setPlayerQueue(selectedTrackId: String) {        
        PlayerQueue.shared.setQueue(ids: [selectedTrackId])
    }
}

