//
//  MovieDetail.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/28/21.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let runtime: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let genres: [Genre]
    let credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case id
        case runtime
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genres
        case credits
    }
}
