//
//  AuthenticationTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Foundation
import Moya

enum AuthenticationTarget {
    case requestToken
    case login(parameters: LoginParameters)
    case createSession(requestToken: String)
}

// MARK: Moya Target Implemetation
extension AuthenticationTarget: TMDBTargetType {
    var requestEndpoint: String {
        switch self {
        case .requestToken:
            return "/authentication/token/new"
        case .login:
            return "/authentication/token/validate_with_login"
        case .createSession:
            return "/authentication/session/new"
        }
    }
    
    var requestMethod: TMDBRequestMethodType {
        switch self {
        case .requestToken:
            return .get
        case .login, .createSession:
            return .post
        }
    }
}

// MARK: Moya Target Implemetation
extension AuthenticationTarget {
    var task: Task {
        switch self {
        case .requestToken:
            let params: [String: Any] = ["api_key": TMDBConfiguration.apiKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .login(let parameters):
            let urlParams: [String: Any] = ["api_key": TMDBConfiguration.apiKey]
            let bodyParams = JSONEncoder().encodeAsDictionary(parameters) ?? [:]
            
            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding.default, urlParameters: urlParams)
        case .createSession(let requestToken):
            let urlParams: [String: Any] = ["api_key": TMDBConfiguration.apiKey]
            let bodyParams: [String: Any] = ["request_token": requestToken]
            
            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding.default, urlParameters: urlParams)
        }
    }
}
