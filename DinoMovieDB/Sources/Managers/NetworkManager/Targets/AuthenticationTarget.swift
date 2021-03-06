//
//  AuthenticationTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Moya

enum AuthenticationTarget {
    case requestToken
    case login(parameters: LoginParameters)
}

extension AuthenticationTarget: MoyaTargetType {
    var path: String {
        switch self {
        case .requestToken:
            return "/authentication/token/new"
        case .login:
            return "/authentication/token/validate_with_login"
        }
    }
    
    var method: Method {
        switch self {
        case .requestToken:
            return .get
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .requestToken:
            return .requestParameters(parameters: TMDBConfiguration.apiKey, encoding: URLEncoding.queryString)
        case .login(let parameters):
            let params = [
                "username": parameters.username,
                "password": parameters.password,
                "request_token": parameters.requestToken
            ]
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: JSONEncoding.default, urlParameters: TMDBConfiguration.apiKey)
        }
    }
}
