//
//  AlbumsViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/29.
//

import MusicKit
import Combine
import UIKit

final class AlbumsViewModel {
    private let network = NetworkService(configuration: .default)
    var albums = CurrentValueSubject<[(id: String, albumUrl: URL?, albumName: String, aritstName: String)]?, Never>(nil)
    var originalAlbums = CurrentValueSubject<MusicItemCollection<Album>?, Never>(nil)
}

extension AlbumsViewModel {
    func fetchArtists() async {
        Spinner.showLoading()
        let url = URL(string: "https://api.music.apple.com/v1/me/library/albums")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        do {
            let response = try await request.response()
            let decoded = try JSONDecoder().decode(MusicItemCollection<Album>.self, from: response.data)
            originalAlbums.send(decoded)
            let parsed = decoded.map { (id: $0.id.rawValue, albumUrl: $0.artwork?.url(width: 60, height: 60), albumName: $0.title, aritstName: $0.artistName) }
            albums.send(parsed)
        } catch {
            print("request failed")
        }
    }
}
