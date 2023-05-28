//
//  ArtistsResponseModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/26.
//

import Foundation

struct ArtistsResponseModel: Codable {
    let next: String
    let data: [ArtistsData]
    let meta: ArtistsMeta
}

struct ArtistsData: Codable {
    let id, type, href: String
    let attributes: Attributes
}

struct ArtistsAttributes: Codable {
    let name: String
}

struct ArtistsMeta: Codable {
    let total: Int
}
