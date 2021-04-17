//
//  TVShowsTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import Foundation
import Moya

enum TVShowsTarget {
    case popular(page: Int)
    case search(show: String, page: Int)
    case fetchShowState(showId: Int, session: SessionToken?)
    case fetchShowDetail(showId: Int, appendToResponse: String?)
    case rate(showId: Int, rate: Rate, session: SessionToken?)
    case deleteRate(showId: Int, session: SessionToken?)
    case fetchFavoriteShows(accountId: Int, session: SessionToken?, page: Int, sortedBy: String)
    case fetchWatchlistShows(accountId: Int, session: SessionToken?, page: Int, sortedBy: String)
    case fetchRatedShows(accountId: Int, session: SessionToken?, page: Int, sortedBy: String)
}

// MARK: TMDBTargetType Implementation
extension TVShowsTarget: TMDBTargetType {
    var requestEndpoint: String {
        switch self {
        case .popular:
            return "/tv/popular"
        case .search:
            return "/search/tv"
        case .fetchShowState(let showId, _):
            return "/tv/\(showId)/account_states"
        case .fetchShowDetail(let showId, _):
            return "/tv/\(showId)"
        case .rate(let showId, _, _):
            return "/tv/\(showId)/rating"
        case .deleteRate(let showId, _):
            return "/tv/\(showId)/rating"
        case .fetchFavoriteShows(let accountId, _, _, _):
            return "/account/\(accountId)/favorite/tv"
        case .fetchRatedShows(let accountId, _, _, _):
            return "/account/\(accountId)/rated/tv"
        case .fetchWatchlistShows(let accountId, _, _, _):
            return "/account/\(accountId)/watchlist/tv"
        }
    }
    
    var requestMethod: TMDBRequestMethodType {
        switch self {
        case .popular, .search, .fetchShowState, .fetchShowDetail, .fetchFavoriteShows, .fetchRatedShows, .fetchWatchlistShows:
            return .get
        case .rate:
            return .post
        case .deleteRate:
            return .delete
        }
    }
}

// MARK: Moya Implementation
extension TVShowsTarget {
    var task: Task {
        switch self {
        case .popular(let page):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "language": TMDBConfiguration.languageCode ?? "en",
                "page": page
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .search(let show, let page):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "language": TMDBConfiguration.languageCode ?? "en",
                "page": page,
                "query": show
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .fetchShowState(_, let session):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": session?.sessionId ?? ""
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .fetchShowDetail(_, let appendToResponse):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "language": TMDBConfiguration.languageCode ?? "en",
                "append_to_response": appendToResponse ?? ""
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .rate(_, let rate, let session):
            let bodyParams = JSONEncoder().encodeAsDictionary(rate) ?? [:]
            let queryParams: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": session?.sessionId ?? ""
            ]
            
            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding.default, urlParameters: queryParams)
        case .deleteRate(_, let session):
            let queryParams: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": session?.sessionId ?? ""
            ]
            
            return .requestParameters(parameters: queryParams, encoding: URLEncoding.queryString)
        case .fetchFavoriteShows(_, let session, let page, let sortedBy),
             .fetchWatchlistShows(_, let session, let page, let sortedBy),
             .fetchRatedShows(_, let session, let page, let sortedBy):
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
