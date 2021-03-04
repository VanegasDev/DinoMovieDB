//
//  AuthenticationTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Moya

enum AuthenticationTarget {
    case requestToken
}

extension AuthenticationTarget: MoyaTargetType {
    var path: String {
        switch self {
        case .requestToken:
            return "/authentication/token/new"
        }
    }
    
    var method: Method {
        switch self {
        case .requestToken:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .requestToken:
            return .requestParameters(parameters: TMDBConfiguration.apiKey, encoding: URLEncoding.queryString)
        }
    }
}
