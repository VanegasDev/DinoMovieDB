//
//  TMDBError.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import Foundation

enum TMDBError: Error {
    case unknownError
    case selfNotFound
    
    var localizedDescription: String {
        switch self {
        case .unknownError: return "Unknown Error"
        case .selfNotFound: return "Self Not Found"
        }
    }
}
