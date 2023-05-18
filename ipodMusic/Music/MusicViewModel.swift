//
//  MusicViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/16.
//

import Foundation
import MusicKit
import Combine

final class MusicViewModel {
    
    var isSubscribing = CurrentValueSubject<Bool, Never>(false)
    
    func checkIsSubscribingFromDB() {
        let isSubscribingFromDB = UserDefaultsManager.getIsSubscribing()
        isSubscribing.send(isSubscribingFromDB)
    }
    
}
