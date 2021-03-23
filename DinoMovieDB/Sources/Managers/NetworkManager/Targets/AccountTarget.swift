//
//  AccountTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/22/21.
//

import Moya

enum AccountTarget {
    case information(session: SessionToken?)
    case logout(session: SessionToken?)
}

extension AccountTarget: MoyaTargetType {
    var path: String {
        switch self {
        case .information:
            return "/account"
        case .logout:
            return "/authentication/session"
        }
    }
    
    var method: Method {
        switch self {
        case .information:
            return .get
        case .logout:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .information(let sessionToken):
            let params: [String: Any] = [
                "api_key": TMDBConfiguration.apiKey,
                "session_id": sessionToken?.sessionId ?? ""
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .logout(let session):
            let urlParams: [String: Any] = ["api_key": TMDBConfiguration.apiKey]
            let bodyParams: [String: Any] = ["session_id": session?.sessionId ?? ""]
            
            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding.default, urlParameters: urlParams)
        }
    }
}
