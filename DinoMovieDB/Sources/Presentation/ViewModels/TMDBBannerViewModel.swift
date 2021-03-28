//
//  TMDBBannerViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import SwiftUI

class TMDBBannerViewModel: ObservableObject {
    let url: URL?
    let title: String
    let releaseDate: String
    let generName: String
    let voteCount: Int
    let isOnWatchlist: Bool
    let isOnFavorites: Bool
    
    let onWatchlist: (Bool) -> Void
    let onFavorites: (Bool) -> Void
    
    init(url: URL?,
         title: String,
         releaseDate: String,
         genderName: String,
         voteCount: Int,
         isOnWatchlist: Bool,
         isOnFavorites: Bool,
         onWatchlist: @escaping (Bool) -> Void,
         onFavorites: @escaping (Bool) -> Void) {
        
        self.url = url
        self.title = title
        self.releaseDate = releaseDate
        self.generName = genderName
        self.voteCount = voteCount
        self.isOnWatchlist = isOnWatchlist
        self.isOnFavorites = isOnFavorites
        self.onWatchlist = onWatchlist
        self.onFavorites = onFavorites
    }
    
    func onWatchlistTap() {
        onWatchlist(isOnWatchlist)
    }
    
    func onFavoritesTap() {
        onFavorites(isOnFavorites)
    }
}
