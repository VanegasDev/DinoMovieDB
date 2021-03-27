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
}

extension TVShowsTarget: MoyaTargetType {
    var path: String  {
        switch self {
        case .popular:
            return "/tv/popular"
        case .search:
            return "/search/tv"
        case .fetchShowState(let showId, _):
            return "/tv/\(showId)/account_states"
        }
    }
    
    var method: Method {
        switch self {
        case .popular, .search, .fetchShowState:
            return .get
        }
    }
    
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
        }
    }
}
