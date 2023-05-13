//
//  Album.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import Foundation

struct AlbumResponse: Codable {
    let data: [Album]
}

struct Album: Codable {
    let id: Int
    let title: String
    let cover: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover = "cover_xl"
        case releaseDate = "release_date"
    }
}

