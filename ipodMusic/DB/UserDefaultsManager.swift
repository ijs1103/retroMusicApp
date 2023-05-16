//
//  UserDefaultsManager.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/15.
//

import Foundation

struct UserDefaultsManager {
    static func getIsSubscribing() -> Bool {
        return UserDefaults.standard.bool(forKey: "isSubscribing")
    }
    static func setIsSubscribing(isSubscribing: Bool) {
        UserDefaults.standard.set(isSubscribing, forKey: "isSubscribing")
    }
}
