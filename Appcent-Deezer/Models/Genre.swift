//
//  Genre.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//

import Foundation

struct GenreResponse: Codable {
    let data: [Genre]

    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
    let picture: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture = "picture_xl"
    }
}


