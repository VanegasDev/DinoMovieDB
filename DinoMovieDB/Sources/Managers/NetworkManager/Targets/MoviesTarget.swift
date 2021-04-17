//
//  MoviesTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/9/21.
//

import Foundation
import Moya

enum MoviesTarget {
    case latest(page: Int)
    case search(movie: String, page: Int)
    case fetchMovieState(movieId: Int, session: SessionToken?)
    case fetchMovieDetail(movieId: Int, appendToResponse: String?)
    case rate(movieId: Int, rate: Rate, session: SessionToken?)
    case deleteRate(movieId: Int, session: SessionToken?)
    case fetchFavoriteMovies(accountId: Int, session: SessionToken?, page: Int, sortedBy: String)
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
        case .fetchMovieDetail(let movieId, _):
            return "/movie/\(movieId)"
        case .rate(let movieId, _, _):
            return "/movie/\(movieId)/rating"
        case .deleteRate(let movieId, _):
            return "/movie/\(movieId)/rating"
        case .fetchFavoriteMovies(let accountId, _, _, _):
            return "/account/\(accountId)/favorite/movies"
        }
    }
    
    var requestMethod: TMDBRequestMethodType {
        switch self {
        case .latest, .search, .fetchMovieState, .fetchMovieDetail, .fetchFavoriteMovies:
            return .get
        case .rate:
            return .post
        case .deleteRate:
            return .delete
        }
    }
}

// MARK: Moya Implementation
extension MoviesTarget {
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
            
        case .fetchMovieDetail(_, let appendToResponse):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "language": TMDBConfiguration.languageCode ?? "en",
                "append_to_response": appendToResponse ?? ""
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .rate(_, let rate, let session):
            let queryParams: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": session?.sessionId ?? ""
            ]
            
            let bodyParams: [String: Any] = JSONEncoder().encodeAsDictionary(rate) ?? [:]
            
            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding.default, urlParameters: queryParams)
            
        case .deleteRate(_, let session):
            let queryParams: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": session?.sessionId ?? ""
            ]
            
            return .requestParameters(parameters: queryParams, encoding: URLEncoding.queryString)
        case .fetchFavoriteMovies(_, let session, let page, let sortedBy):
            let queryParams: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": session?.sessionId ?? "",
                "language": TMDBConfiguration.languageCode ?? "en",
                "sort_by": sortedBy,
                "page": page
            ]
            
            return .requestParameters(parameters: queryParams, encoding: URLEncoding.queryString)
        }
    }
}
