//
//  MoviesTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/9/21.
//

import Moya

enum MoviesTarget {
    case latest(page: Int)
}

extension MoviesTarget: MoyaTargetType {
    var path: String  {
        switch self {
        case .latest:
            return "/movie/upcoming"
        }
    }
    
    var method: Method {
        switch self {
        case .latest:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .latest(let page):
            var params = TMDBConfiguration.apiKey
            params["language"] = TMDBConfiguration.languageCode
            params["page"] = page
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
