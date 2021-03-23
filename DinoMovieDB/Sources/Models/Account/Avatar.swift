//
//  Avatar.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/22/21.
//

import Foundation

struct Avatar: Codable {
    let tmdbAvatarInformation: TMDBAvatarInformation
    
    enum CodingKeys: String, CodingKey {
        case tmdbAvatarInformation = "tmdb"
    }
}

struct TMDBAvatarInformation: Codable {
    let path: String
    
    enum CodingKeys: String, CodingKey {
        case path = "avatar_path"
    }
}
