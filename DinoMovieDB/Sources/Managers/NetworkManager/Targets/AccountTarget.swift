//
//  AccountTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/22/21.
//

import Moya

enum AccountTarget {
    case information(session: SessionToken?)
}

extension AccountTarget: MoyaTargetType {
    var path: String {
        switch self {
        case .information:
            return "/account"
        }
    }
    
    var method: Method {
        switch self {
        case .information:
            return .get
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
        }
    }
}
