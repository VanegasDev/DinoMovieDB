//
//  AccountTarget.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/22/21.
//

import Foundation
import Moya

enum AccountTarget {
    case information(session: SessionToken?)
    case logout(session: SessionToken?)
    case markAsFavorite(accountId: Int, params: FavoritesState, session: SessionToken?)
    case addToWatchlist(accountId: Int, params: WatchlistsState, session: SessionToken?)
}

extension AccountTarget: MoyaTargetType {
    var path: String {
        switch self {
        case .information:
            return "/account"
        case .logout:
            return "/authentication/session"
        case .addToWatchlist(let accountId, _, _):
            return "/account/\(accountId)/watchlist"
        case .markAsFavorite(let accountId, _, _):
            return "/account/\(accountId)/favorite"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .information:
            return .get
        case .logout:
            return .delete
        case .addToWatchlist, .markAsFavorite:
            return .post
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
            
        case .addToWatchlist(_, let params, let session):
            let urlParams: [String: Any] = [
                "session_id": session?.sessionId ?? "",
                "api_key":  TMDBConfiguration.apiKey
            ]
            
            return .requestCompositeParameters(bodyParameters: JSONEncoder().encodeAsDictionary(params) ?? [:], bodyEncoding: JSONEncoding.default, urlParameters: urlParams)
            
        case .markAsFavorite(_, let params, let session):
            let urlParams: [String: Any] = [
                "session_id": session?.sessionId ?? "",
                "api_key":  TMDBConfiguration.apiKey
            ]
            
            return .requestCompositeParameters(bodyParameters: JSONEncoder().encodeAsDictionary(params) ?? [:], bodyEncoding: JSONEncoding.default, urlParameters: urlParams)
        }
    }
}
