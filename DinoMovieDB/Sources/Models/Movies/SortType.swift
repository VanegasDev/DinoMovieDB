//
//  SortType.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/16/21.
//

import Foundation

enum SortType {
    case ascendant
    case descendat
    
    var queryParam: String {
        switch self {
        case .ascendant: return "created_at.asc"
        case .descendat: return "created_at.desc"
        }
    }
}
