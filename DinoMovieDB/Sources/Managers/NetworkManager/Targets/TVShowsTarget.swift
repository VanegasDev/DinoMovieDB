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
}

extension TVShowsTarget: MoyaTargetType {
    var path: String  {
        switch self {
        case .popular:
            return "/tv/popular"
        case .search:
            return "/search/tv"
        }
    }
    
    var method: Method {
        switch self {
        case .popular, .search:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .popular(let page):
            var params = TMDBConfiguration.apiKey
            params["language"] = TMDBConfiguration.languageCode
            params["page"] = page
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .search(let show, let page):
            var params = TMDBConfiguration.apiKey
            params["language"] = TMDBConfiguration.languageCode
            params["page"] = page
            params["query"] = show
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
