//
//  PlayListsViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/17.
//
import Foundation
import MusicKit
import Combine
import UIKit

typealias ParsedPlayList = (id: String, albumUrl: URL?, title: String, subTitle: String, duration: Int?, albumTitle: String?, albumImage: UIImage?)
typealias OriginalPlayLists = MusicItemCollection<Playlist>
final class PlayListsViewModel {
    private var subscriptions = Set<AnyCancellable>()
    var playLists = CurrentValueSubject<[ParsedPlayList]?, Never>(nil)
    var originalPlayLists = CurrentValueSubject<OriginalPlayLists?, Never>(nil)
}

extension PlayListsViewModel {
    func fetchPlayLists() async{
        Spinner.showLoading()
        let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        do {
            let response = try await request.response()
            let decoded = try JSONDecoder().decode(OriginalPlayLists.self, from: response.data)
            originalPlayLists.send(decoded)
            let parsedPlayLists: [ParsedPlayList] = decoded.map { return (id: $0.id.rawValue, albumUrl: $0.artwork?.url(width: 60, height: 60), title: $0.name,  subTitle: $0.standardDescription ?? "", duration: nil, albumTitle: nil, albumImage: nil)}
            playLists.send(parsedPlayLists)
        } catch {
            print("request failed")
        }
    }
}
