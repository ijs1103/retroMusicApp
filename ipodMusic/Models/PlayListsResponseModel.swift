//
//  PlayListsResponseModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/17.
//

import Foundation

struct PlayListsResponseModel: Codable {
    let next: String
    let data: [Data]
    let meta: Meta
}

struct Data: Codable {
    let id, type, href: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let playParams: PlayParams
    let hasCatalog, canEdit, isPublic: Bool
    let name, dateAdded: String
}

struct PlayParams: Codable {
    let id, kind: String
    let isLibrary: Bool
}

struct Meta: Codable {
    let total: Int
}
