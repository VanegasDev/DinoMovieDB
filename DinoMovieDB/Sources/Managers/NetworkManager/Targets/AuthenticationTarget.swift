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
    case createSession(requestToken: String)
}

extension AuthenticationTarget: MoyaTargetType {
    var path: String {
        switch self {
        case .requestToken:
            return "/authentication/token/new"
        case .login:
            return "/authentication/token/validate_with_login"
        case .createSession:
            return "/authentication/session/new"
        }
    }
    
    var method: Method {
        switch self {
        case .requestToken:
            return .get
        case .login, .createSession:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .requestToken:
            return .requestParameters(parameters: TMDBConfiguration.apiKey, encoding: URLEncoding.queryString)
        case .login(let parameters):
            let params: [String: Any] = [
                "username": parameters.username,
                "password": parameters.password,
                "request_token": parameters.requestToken
            ]
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: JSONEncoding.default, urlParameters: TMDBConfiguration.apiKey)
        case .createSession(let requestToken):
            let params: [String: Any] = ["request_token": requestToken]
            
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: JSONEncoding.default, urlParameters: TMDBConfiguration.apiKey)
        }
    }
}
