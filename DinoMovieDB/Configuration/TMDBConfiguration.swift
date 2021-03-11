//
//  TMDBConfiguration.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Foundation

enum TMDBConfiguration {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let apiKey: [String: Any] = ["api_key": "564e54a030d631c7e0de441d30cda68c"]
    static let languageCode = Locale.current.languageCode
    static let imageBasePath = "https://image.tmdb.org/t/p/w500"
}
