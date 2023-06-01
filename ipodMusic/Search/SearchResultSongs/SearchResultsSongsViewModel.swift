//
//  SearchResultsSongsViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/06/01.
//

import MusicKit
import Combine
import UIKit

final class SearchResultsSongsViewModel {
    let data: [AlbumsDatum]
    private var subscriptions = Set<AnyCancellable>()
    var songs: [ParsedPlayList] {
        return data.map {
            return (id: $0.id, albumUrl: $0.attributes?.artwork.url.stringToAlbumUrl(), title: $0.attributes?.name ?? "No Name",  subTitle: $0.attributes?.artistName ?? "No Name", duration: (($0.attributes?.durationInMillis ?? 0) / 1000), albumTitle: $0.attributes?.albumName, albumImage: nil)
        }
    }
    init(with data: [AlbumsDatum]) {
        self.data = data
    }
}

extension SearchResultsSongsViewModel {
    func setPlayerQueue(selectedTrackId: String) {
        PlayerQueue.shared.setQueue(ids: [selectedTrackId])
    }
}
