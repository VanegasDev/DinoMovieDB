//
//  TVShowPreview.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/10/21.
//

import Foundation

protocol ItemPreviewType {
    var id: Int { get }
    var title: String? { get }
    var releaseDate: String? { get }
    var imagePath: String? { get }
    var voteAverage: Double? { get }
}

struct TVShowPreview: Codable, ItemPreviewType {
    let id: Int
    let title: String?
    let releaseDate: String?
    let imagePath: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case releaseDate = "first_air_date"
        case imagePath = "poster_path"
        case voteAverage = "vote_average"
    }
}
