//
//  NowPlayingViewModel.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/19.
//

import Foundation
import Combine
import MusicKit

final class NowPlayingViewModel {
    var playList: ParsedPlayList
    var duration = 0
    var currentSeconds = 0
    private var subscriptions = Set<AnyCancellable>()
    init(with playList: ParsedPlayList) {
        self.playList = playList
        self.duration = playList.duration ?? 0
    }
}

extension NowPlayingViewModel {
    func updatePlayList(with playList: ParsedPlayList) {
        self.playList = playList
        self.duration = playList.duration ?? 0
        self.currentSeconds = 0
    }
    func play() async {
        Spinner.showLoading()
        PlayerQueue.shared.playTrack()
        Spinner.hideLoading()
    }
    func isSongEmpty() -> Bool {
        return PlayerQueue.shared.isQueueEmpty()
    }
    func playNextSong() {
        PlayerQueue.shared.playNextSong()
    }
    func playPrevSong() {
        PlayerQueue.shared.playPrevSong()
    }
    func getTrack() -> ParsedPlayList? {
        guard let song = PlayerQueue.shared.showCurrentSong() else { return nil }
        return (id: song.playbackStoreID , albumUrl: nil, title: song.title!, subTitle: song.artist!, duration: Int(song.playbackDuration), albumTitle: song.albumTitle!, albumImage: song.artwork?.image(at: CGSize(width: 600.0, height: 600.0)))
    }
    func isRemainingSongsInQueue() -> Bool {
        return PlayerQueue.shared.showCurrentSong() != nil
    }
    func pause() {
        SystemMusicPlayer.shared.pause()
    }
    func changePlaybackTime(seconds: Int) {
        SystemMusicPlayer.shared.playbackTime = Double(seconds)
    }
    func setRepeatMode() {
        switch ControlStatus.shared.repeatMode {
        case .repeatOn:
            SystemMusicPlayer.shared.state.repeatMode = .all
        case .repeatOff:
            SystemMusicPlayer.shared.state.repeatMode = nil
        case .repeatOne:
            SystemMusicPlayer.shared.state.repeatMode = .one
        }
    }
    func setShuffleMode() {
        switch ControlStatus.shared.shuffleMode {
        case .shuffleOn:
            SystemMusicPlayer.shared.state.shuffleMode = .songs
        case .shuffleOff:
            SystemMusicPlayer.shared.state.shuffleMode = .off
        }
    }
    
}
