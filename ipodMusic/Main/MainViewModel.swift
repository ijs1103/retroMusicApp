//
//  MainViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/15.
//
import Foundation
import MusicKit
import Combine

final class MainViewModel {
    
    var isSubscribing = CurrentValueSubject<Bool, Never>(false)
    
    func checkIsSubscribingFromDB() {
        let isSubscribingFromDB = UserDefaultsManager.getIsSubscribing()
        isSubscribing.send(isSubscribingFromDB)
    }
}
