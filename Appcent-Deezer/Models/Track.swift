//
//  Track.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import Foundation

struct Tracks: Codable {
    let tracks: TrackData
}

struct TrackData: Codable {
    let data: [Track]
}

struct Track: Codable {
    let id: Int
    let title: String
    let duration: Int?
    let preview: String?
    let album: TrackAlbum
    
    enum CodingKeys: String, CodingKey {
        case id, title, duration, album, preview
    }
}

struct TrackAlbum: Codable {
    let id: Int
    let title: String
    let cover_xl: String
}


