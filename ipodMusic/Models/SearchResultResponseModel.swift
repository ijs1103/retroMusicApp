//
//  SearchResultResponseModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/29.
//

import Foundation

struct SearchResult: Codable {
    let results: SearchResultResults
    let meta: Meta
}

struct Meta: Codable {
    let results: MetaResults
}

struct MetaResults: Codable {
    let order, rawOrder: [String]
}

struct SearchResultResults: Codable {
    let artists: Artists
    let songs: Songs
}

struct Artists: Codable {
    let href: String
    let data: [ArtistsDatum]
}

struct ArtistsDatum: Codable {
    let id, type, href: String
    let attributes: PurpleAttributes
    let relationships: Relationships
}

struct PurpleAttributes: Codable {
    let name: String
    let genreNames: [String]
    let artwork: Artwork
    let url: String
}

struct Artwork: Codable {
    let width, height: Int
    let url, bgColor, textColor1, textColor2: String
    let textColor3, textColor4: String
}

struct Relationships: Codable {
    let albums: RealtedAlbums
}

struct RealtedAlbums: Codable {
    let href: String
    let data: [AlbumsDatum]
}

struct AlbumsDatum: Codable {
    let id, type, href: String
    let attributes: FluffyAttributes?
}

struct FluffyAttributes: Codable {
    let albumName: String
    let genreNames: [String]
    let trackNumber: Int
    let releaseDate: String
    let durationInMillis: Int
    let isrc: String
    let artwork: Artwork
    let url: String
    let playParams: PlayParams
    let discNumber: Int
    let isAppleDigitalMaster, hasLyrics: Bool
    let name: String
    let previews: [Preview]
    let artistName: String
}

struct PlayParams: Codable {
    let id, kind: String
}

struct Preview: Codable {
    let url: String
}

struct Songs: Codable {
    let href, next: String
    let data: [AlbumsDatum]
}


