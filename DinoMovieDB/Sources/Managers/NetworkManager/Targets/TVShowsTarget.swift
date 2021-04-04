//
//  TVShowsTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import Moya

enum TVShowsTarget {
    case popular(page: Int)
    case search(show: String, page: Int)
    case fetchShowState(showId: Int, session: SessionToken?)
    case fetchShowDetail(showId: Int, appendToResponse: String?)
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
        }
    }
    
    var requestMethod: TMDBRequestMethodType {
        switch self {
        case .popular, .search, .fetchShowState, .fetchShowDetail:
            return .get
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
        }
    }
}
