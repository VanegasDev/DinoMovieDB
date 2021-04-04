//
//  ShowDetail.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/3/21.
//

import Foundation

struct ShowDetail: Decodable {
    let id: Int
    let runtime: [Int]
    let seasons: [Season]
    let creators: [ShowCreator]
    let title: String
    let overview: String
    let posterPath: String
    let firstAirDate: String?
    let voteAverage: Double?
    let genres: [Genre]
    let credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case id
        case runtime = "episode_run_time"
        case seasons
        case creators = "created_by"
        case title = "name"
        case overview
        case posterPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case genres
        case credits
    }
}

struct Season: Decodable, Identifiable {
    let id: Int
    let seasonNumber: Int
    let numberOfEpisodes: Int
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case seasonNumber = "season_number"
        case numberOfEpisodes = "episode_count"
        case posterPath = "poster_path"
    }
}

struct ShowCreator: Decodable {
    let id: Int
    let name: String
}
