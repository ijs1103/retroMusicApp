//
//  ArtistsDetailViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/26.
//

import MusicKit
import Combine
import UIKit

typealias AlbumByArtist = (id: String, albumUrl: URL?, albumName: String)

final class ArtistsDetailViewModel {
    private let id: String
    private var subscriptions = Set<AnyCancellable>()
    var albumsByArtist = CurrentValueSubject<[AlbumByArtist]?, Never>(nil)
    var originalAlbums = CurrentValueSubject<MusicItemCollection<Album>?, Never>(nil)
    init(id: String) {
        self.id = id
    }
}

extension ArtistsDetailViewModel {
    func fetchAlbumsByArtist() async {
        Spinner.showLoading()
        let url = URL(string: "https://api.music.apple.com/v1/me/library/artists/\(id)/albums")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        do {
            let response = try await request.response()
            let decoded = try JSONDecoder().decode(MusicItemCollection<Album>.self, from: response.data)
            originalAlbums.send(decoded)
            let parsed = decoded.map { (id: $0.id.rawValue, albumUrl: $0.artwork?.url(width: 60, height: 60), albumName: $0.title) }
            albumsByArtist.send(parsed)
        } catch {
            print("request failed")
        }
    }
}
