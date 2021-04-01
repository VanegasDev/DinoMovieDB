//
//  AccountState.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/24/21.
//

import Foundation

struct FavoritesState: Encodable {
    let mediaType: String
    let itemId: Int
    let isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case itemId = "media_id"
        case isFavorite = "favorite"
    }
}

struct WatchlistsState: Encodable {
    let mediaType: String
    let itemId: Int
    let isOnWatchList: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case itemId = "media_id"
        case isOnWatchList = "watchlist"
    }
}

struct Rate: Codable {
    let value: Double
}

struct ItemState: Codable {
    let id: Int
    let isFavorite: Bool
    let isOnWatchlist: Bool
    let rating: Rate?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isFavorite = "favorite"
        case isOnWatchlist = "watchlist"
        case rating = "rated"
    }
    
    init(from decoder: Decoder) throws {
        let container =  try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        isOnWatchlist = try container.decode(Bool.self, forKey: .isOnWatchlist)
        rating = try? container.decode(Rate.self, forKey: .rating)
    }
}
