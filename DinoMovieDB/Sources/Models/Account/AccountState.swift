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

struct ItemState: Codable {
    let id: Int
    let isFavorite: Bool
    let isOnWatchlist: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case isFavorite = "favorite"
        case isOnWatchlist = "watchlist"
    }
}
