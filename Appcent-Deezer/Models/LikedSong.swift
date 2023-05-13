//
//  LikedSong.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import Foundation

class LikedSongsManager {
    static let shared = LikedSongsManager()
    
    private var likedSongs: [Track] = []
    
    private init() {}
    
    func addTrack(_ track: Track) {
        likedSongs.append(track)
        print("added song")
    }
    
    func removeTrack(_ track: Track) {
        if let index = likedSongs.firstIndex(where: { $0.id == track.id }) {
            likedSongs.remove(at: index)
        }
    }
    
    func getLikedSongs() -> [Track] {
        return likedSongs
    }
}
