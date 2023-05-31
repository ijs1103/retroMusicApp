//
//  SearchResultArtistsViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/30.
//

import Combine

typealias SearchResultAritstDataType = (id: String, artistName: String, endpoint: String)
final class SearchResultArtistsViewModel {
    private let data: [ArtistsDatum]
    private var subscriptions = Set<AnyCancellable>()
    var parsedData: [SearchResultAritstDataType] {
        return data.map {
            (id: $0.id, artistName: $0.attributes.name, endpoint: $0.href)
        }
    }
    init(with data: [ArtistsDatum]) {
        self.data = data
    }
}
