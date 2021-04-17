//
//  TMDBMediaType.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

enum MediaType: Int {
    case movies
    case tvShows
    
    var name: String {
        switch self {
        case .movies: return "movie"
        case .tvShows: return "tv"
        }
    }
}
