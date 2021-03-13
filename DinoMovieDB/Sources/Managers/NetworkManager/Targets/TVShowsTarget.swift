//
//  TVShowsTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import Moya

enum TVShowsTarget {
    case popular(page: Int)
}

extension TVShowsTarget: MoyaTargetType {
    var path: String  {
        switch self {
        case .popular:
            return "/tv/popular"
        }
    }
    
    var method: Method {
        switch self {
        case .popular:
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
        }
    }
}
