//
//  MoviePreview.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/9/21.
//

import Foundation

struct MoviePreview: Codable, ItemPreviewType {
    let id: Int
    let title: String?
    let releaseDate: String?
    let imagePath: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case imagePath = "poster_path"
        case voteAverage = "vote_average"
    }
}
