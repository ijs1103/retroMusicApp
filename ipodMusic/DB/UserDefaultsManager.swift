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
    static func setNowPlayingState(nowPlayingState: NowPlayingState) {
        if let encoded = try? JSONEncoder().encode(nowPlayingState) {
            UserDefaults.standard.set(encoded, forKey: "NowPlayingState")
        }
    }
    static func getNowPlayingState() -> NowPlayingState? {
        if let object = UserDefaults.standard.object(forKey: "NowPlayingState") as? Data {
            if let nowPlayingState = try? JSONDecoder().decode(NowPlayingState.self, from: object) {
                return nowPlayingState
            }
        }
        print("JSON Decoding Failed")
        return nil
    }
}
