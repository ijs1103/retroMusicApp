//
//  SearchResultArtistsDetailViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/30.
//

import MusicKit
import Combine
import UIKit

final class SearchResultArtistsDetailViewModel {
    private let data: SearchResultAritstDataType
    private var subscriptions = Set<AnyCancellable>()
    var originalAlbums = CurrentValueSubject<MusicItemCollection<Album>?, Never>(nil)
    var albums = CurrentValueSubject<[(id: String, albumUrl: URL?, albumName: String, artistName: String)]?, Never>(nil)
    init(with data: SearchResultAritstDataType) {
        self.data = data
    }
}

extension SearchResultArtistsDetailViewModel {
    func fetchAlbumsByArtist() async {
        Spinner.showLoading()
        let url = URL(string: "https://api.music.apple.com/v1/catalog/us/artists/\(data.id)/albums")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        do {
            let response = try await request.response()
            let decoded = try JSONDecoder().decode(MusicItemCollection<Album>.self, from: response.data)
            originalAlbums.send(decoded)
            let parsed = decoded.map {
                (id: $0.id.rawValue, albumUrl: $0.artwork?.url(width: 60, height: 60), albumName: $0.title, artistName: $0.artistName)
            }
            albums.send(parsed)
        } catch {
            print("request failed")
        }
    }
}
