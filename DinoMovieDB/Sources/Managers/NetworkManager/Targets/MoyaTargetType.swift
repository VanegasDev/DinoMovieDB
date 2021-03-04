//
//  MoyaTargetType.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Foundation
import Moya

protocol MoyaTargetType: TargetType {}

extension MoyaTargetType {
    var baseURL: URL {
        guard let url = URL(string: TMDBConfiguration.baseUrl) else {
            fatalError("Base URL Couldn't be Configured")
        }
        
        return url
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var sampleData: Data {
        Data()
    }
}
