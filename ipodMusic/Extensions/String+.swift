//
//  String+.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/06/01.
//

import Foundation

extension String {
    func stringToAlbumUrl() -> URL? {
        let replaced = self.replacingOccurrences(of: "{w}x{h}", with: "600x600")
        return URL(string: replaced)
    }
}
