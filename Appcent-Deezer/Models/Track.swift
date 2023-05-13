//
//  Track.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import Foundation

struct Tracks: Codable, Equatable {
    let tracks: TrackData
    let id: Int
    
    static func == (lhs: Tracks, rhs: Tracks) -> Bool {
            return lhs.id == rhs.id && lhs.tracks == rhs.tracks
        }
}

struct TrackData: Codable, Equatable {
    let data: [Track]
    static func == (lhs: TrackData, rhs: TrackData) -> Bool {
            return lhs.data == rhs.data
        }
}

struct Track: Codable, Equatable {
    let id: Int
    let title: String
    let duration: Int?
    let preview: String?
    let album: TrackAlbum
    
    static func == (lhs: Track, rhs: Track) -> Bool {
            return lhs.id == rhs.id
        }
    
    enum CodingKeys: String, CodingKey {
        case id, title, duration, album, preview
    }
}

struct TrackAlbum: Codable {
    let id: Int
    let title: String
    let cover_xl: String
}


