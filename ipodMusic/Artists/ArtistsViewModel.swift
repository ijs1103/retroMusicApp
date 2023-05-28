//
//  ArtistsViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/26.
//

import MusicKit
import Combine
import UIKit

final class ArtistsViewModel {
    private let network = NetworkService(configuration: .default)
    var artists = CurrentValueSubject<[(id: String, artistName: String)]?, Never>(nil)
}

extension ArtistsViewModel {
    func fetchArtists() async {
        Spinner.showLoading()
        let url = URL(string: "https://api.music.apple.com/v1/me/library/artists")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        do {
            let response = try await request.response()
            let decoded = try JSONDecoder().decode(MusicItemCollection<Artist>.self, from: response.data)
            let parsed = decoded.map { (id: $0.id.rawValue, artistName: $0.name)}
            artists.send(parsed)
        } catch {
            print("request failed")
        }
    }
}
