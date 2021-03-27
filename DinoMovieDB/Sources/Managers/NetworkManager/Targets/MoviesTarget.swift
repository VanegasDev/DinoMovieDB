//
//  MoviesTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/9/21.
//

import Moya

enum MoviesTarget {
    case latest(page: Int)
    case search(movie: String, page: Int)
    case fetchMovieState(movieId: Int, session: SessionToken?)
}

// MARK: TMDBTargetType Implementation
extension MoviesTarget: TMDBTargetType {
    var requestEndpoint: String {
        switch self {
        case .latest:
            return "/movie/upcoming"
        case .search:
            return "/search/movie"
        case .fetchMovieState(let movieId, _):
            return "/movie/\(movieId)/account_states"
        }
    }
    
    var requestMethod: TMDBRequestMethodType {
        switch self {
        case .latest, .search, .fetchMovieState:
            return .get
        }
    }
}

// MARK: Moya Implementation
extension MoviesTarget {
    var path: String {
        requestEndpoint
    }
    
    var task: Task {
        switch self {
        case .latest(let page):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "language": TMDBConfiguration.languageCode ?? "en",
                "page": page
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .search(let movie, let page):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "language": TMDBConfiguration.languageCode ?? "en",
                "page": page,
                "query": movie
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .fetchMovieState(_, let session):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": session?.sessionId ?? ""
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
