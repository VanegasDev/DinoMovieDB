//
//  TVShowPreview.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/10/21.
//

import Foundation

struct TVShowPreview: Codable {
    let id: Int
    let name: String
    let releaseDate: String
    let imagePath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case releaseDate = "first_air_date"
        case imagePath = "poster_path"
        case voteAverage = "vote_average"
    }
}
