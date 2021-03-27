//
//  MoyaTargetType.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Foundation
import Moya

enum TMDBRequestMethodType {
    case get
    case post
    case patch
    case put
    case delete
}

protocol TMDBTargetType: TargetType {
    var requestEndpoint: String { get }
    var requestHeaders: [String: String]? { get }
    var requestMethod: TMDBRequestMethodType { get }
}

// MARK: TMDBTargetType Implementation
extension TMDBTargetType {
    var requestHeaders: [String: String]? {
        ["Content-Type": "application/json"]
    }
}

// MARK: Moya Protocol Implementation
extension TMDBTargetType {
    var baseURL: URL {
        guard let url = URL(string: TMDBConfiguration.baseUrl) else {
            fatalError("Base URL Couldn't be Configured")
        }
        
        return url
    }
    
    var headers: [String : String]? {
        requestHeaders
    }
    
    var method: Moya.Method {
        switch requestMethod {
        case .delete: return .delete
        case .post: return .post
        case .get: return .get
        case .patch: return .patch
        case .put: return .put
        }
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var sampleData: Data {
        Data()
    }
}
