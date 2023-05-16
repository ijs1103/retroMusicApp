//
//  SettingsViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/15.
//

import MusicKit
import Combine

final class SettingsViewModel {
    
    var isSubscribing = CurrentValueSubject<Bool, Never>(false)
    // 로그인, 로그아웃 토글
    func toggleSigninOut() {
        if isSubscribing.value {
            isSubscribing.send(false)
            UserDefaultsManager.setIsSubscribing(isSubscribing: false)
        } else {
            Task {
                await checkMusicAuth()
                await checkAppleMusicSubscribe()
            }
        }
    }
    
    func checkIsSubscribingFromDB() {
        let isSubscribingFromDB = UserDefaultsManager.getIsSubscribing()
        isSubscribing.send(isSubscribingFromDB)
    }

    private func checkMusicAuth() async {
        let status = MusicAuthorization.currentStatus
        if status == .authorized {
            return
        } else {
            let status = await MusicAuthorization.request()
            if status != .authorized {
                print("permission Denied")
            }
        }
    }
    
    private func checkAppleMusicSubscribe() async  {
        do {
            let subscription = try await MusicSubscription.current
            // apple music 구독중이면
            if subscription.canPlayCatalogContent {
                isSubscribing.send(true)
                UserDefaultsManager.setIsSubscribing(isSubscribing: true)
            } else {
                isSubscribing.send(false)
                UserDefaultsManager.setIsSubscribing(isSubscribing: false)
            }
        } catch {
            let subscriptionError = error as! MusicSubscription.Error
            switch subscriptionError {
            case .permissionDenied:
                print("permission Denied")
            case .privacyAcknowledgementRequired:
                print("privacy Acknowledgement Required")
            case .unknown:
                print("unknown error")
            @unknown default:
                fatalError()
            }
        }
    }
}
