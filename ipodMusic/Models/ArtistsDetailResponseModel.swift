//
//  ArtistsDetailResponseModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/26.
//

import Foundation

struct ArtistsDetailResponseModel: Codable {
    let data: [ArtistsDetailData]
    let meta: ArtistsDetailMeta
}

struct ArtistsDetailData: Codable {
    let id, type, href: String
    let attributes: ArtistsDetailAttributes
}

struct ArtistsDetailAttributes: Codable {
    let trackCount: Int
    let genreNames: [String]
    let releaseDate, name, artistName: String
    let artwork: ArtistsDetailArtwork
    let dateAdded: Date
    let playParams: ArtistsDetailPlayParams
}

struct ArtistsDetailArtwork: Codable {
    let width, height: Int
    let url: String
}

struct ArtistsDetailPlayParams: Codable {
    let id, kind: String
    let isLibrary: Bool
}

struct ArtistsDetailMeta: Codable {
    let total: Int
}
