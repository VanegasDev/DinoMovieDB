//
//  MovieCredits.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/28/21.
//

import Foundation

struct CastPerson: Decodable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}

struct CrewPerson: Decodable {
    let id: Int
    let name: String
    let job: String
}

struct Credits: Decodable {
    let cast: [CastPerson]
    let crew: [CrewPerson]
}
