//
//  Artists.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//

import Foundation

struct ArtistResponse: Codable {
    let data: [Artist]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Artist: Codable {
    let id: Int
    let name: String
    let picture_xl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, picture_xl
    }
}

