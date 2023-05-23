//
//  PlayerQueue.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/19.
//

import Foundation
import MediaPlayer
import MusicKit

final class PlayerQueue {
    static let shared = PlayerQueue()
    private init() {}
    private var player = MPMusicPlayerController.systemMusicPlayer
    
    func playNextSong() {
        player.skipToNextItem()
    }
    func playPrevSong() {
        player.skipToPreviousItem()
    }
    func showCurrentSong() -> MPMediaItem? {
        return player.nowPlayingItem
    }
    
    // MARK: - Play All
    /// Plays all the songs in an array of ids. Staring with the first and prepending the rest to the queue
    /// - Parameter ids: The song ids from the Apple Music catalog to play
    func playAll(ids: [String]) {
        if ids.count <= 0 {
            print("PlayerQueue - There are no ids to play")
            return
        }
        
        setQueue(ids: ids)
        player.play()
    }
    
    // MARK: - Shuffle All
    /// Shuffles all the songs in an array of song ids. Staring with the first and prepending the rest to the queue
    /// - Parameter ids: The song ids from the Apple Music catalog to play
    func shuffleAll(ids: [String]) {
        if ids.count <= 0 {
            print("PlayerQueue - There are no ids to shuffle")
            return
        }
        
        let shuffled = ids.shuffled()
        setQueue(ids: shuffled)
        player.play()
    }
    
    // MARK: - Prepend Catalog Array
    /// Prepends an array of song ids to the beginning of the queue
    /// - Parameter ids: The song ids from the Apple Music catalog to prepend
    func prepend(ids: [String]) {
        if ids.count <= 0 {
            print("PlayerQueue - There are no ids to prepend")
            return
        }
        
        let parameters = getParametersFrom(ids: ids)
        player.prepend(MPMusicPlayerPlayParametersQueueDescriptor(playParametersQueue: parameters))
    }
    
    // MARK: - Prepend Catalog Song
    /// Prepends a song to the beginning of the queue
    /// - Parameter ids: The song id from the Apple Music catalog to prepend
    func prepend(id: String) {
        prepend(ids: [id])
    }
    
    // MARK: - Append Catalog Array
    /// Appends an array of songs to the end of the queue
    /// - Parameter ids: The song ids from the Apple Music catalog to append
    func append(ids: [String]) {
        if ids.count <= 0 {
            print("PlayerQueue - There are no ids to append")
            return
        }
        let parameters = getParametersFrom(ids: ids)
        player.append(MPMusicPlayerPlayParametersQueueDescriptor(playParametersQueue: parameters))
    }
    
    // MARK: - Append Catalog Song
    /// Appends a song from the Apple Music catalog to the end of the queue
    /// - Parameter ids: The song id from the Apple Music catalog to append
    func append(id: String) {
        append(ids: [id])
    }
    
    // MARK: - Set Queue
    /// Sets the queue to an array of Apple Music catalog ids, removing any items previously in the queue
    /// - Parameter ids: The song ids from the Apple Music catalog to add
    func setQueue(ids: [String]) {
        if ids.count <= 0 {
            print("PlayerQueue - There are no ids to set")
            return
        }
        
        let parameters = getParametersFrom(ids: ids)
        player.setQueue(with: MPMusicPlayerPlayParametersQueueDescriptor(playParametersQueue: parameters))
        player.prepareToPlay()
    }
    
    
    // MARK: - Get Catalog ID Parameters
    private func getParametersFrom(ids: [String]) -> [MPMusicPlayerPlayParameters] {
        var parameters = [MPMusicPlayerPlayParameters]()
        for id in ids {
            if let parameter = MPMusicPlayerPlayParameters(dictionary: ["id": id, "kind": "song"]) {
                parameters.append(parameter)
            } else {
                print("PlayerQueue - Could not create play parameters from catalog id \(id)")
            }
        }
        return parameters
    }
}
