//
//  SearchViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/29.
//
import MusicKit
import Combine
import UIKit

typealias SearchResultsType = (artists: [ArtistsDatum], songs: [AlbumsDatum])
typealias SearchCountType = (artists: Int, songs: Int)

final class SearchViewModel {
    private let network = NetworkService(configuration: .default)
    private var subscriptions = Set<AnyCancellable>()
    var searchTerm = CurrentValueSubject<String, Never>("")
    var searchResults = CurrentValueSubject<SearchResultsType?, Never>(nil)
    var searchCount = CurrentValueSubject<SearchCountType?, Never>(nil)
    init() {
        self.bindSearchTerm()
    }
}

extension SearchViewModel {
    private func bindSearchTerm() {
        searchTerm.receive(on: RunLoop.main)
            .sink { [unowned self] term in
                guard term != "" else { return }
            Task {
                await search(term: term)
            }
        }.store(in: &subscriptions)
    }
    func search(term: String) async {
        Spinner.showLoading()
        let url = URL(string: "https://api.music.apple.com/v1/catalog/us/search?types=albums,artists,songs&term=\(term)")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        do {
            let response = try await request.response()
            let decoded = try JSONDecoder().decode(SearchResult.self, from: response.data)
            let results = decoded.results
            let artistsData = results.artists.data
            let songsData = results.songs.data
            searchResults.send((artists: artistsData, songs: songsData))
            searchCount.send((artists: artistsData.count, songs: songsData.count))
        } catch {
            searchResults.send(nil)
            searchCount.send(nil)
            print("No search results")
            return 
        }
    }
    func didChangeSearchTerm(with term: String) {
        searchTerm.send(term)
    }
}
