//
//  TMDBBannerViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import SwiftUI

class TMDBBannerViewModel: ObservableObject {
    @Published var isFavoriteButtonEnabled: Bool = true
    @Published var isWatchlistButtonEnabled: Bool = true
    @Published var isOnWatchlist: Bool = false
    @Published var isOnFavorites: Bool = false
    
    let url: URL?
    let title: String
    let releaseDate: String
    let generName: String
    let voteAverage: String
    
    let onWatchlist: (Bool) -> Void
    let onFavorites: (Bool) -> Void
    
    init(url: URL?,
         title: String,
         releaseDate: String,
         genderName: String,
         voteAverage: String,
         onWatchlist: @escaping (Bool) -> Void,
         onFavorites: @escaping (Bool) -> Void) {
        
        self.url = url
        self.title = title
        self.releaseDate = DateFormatter.tmdbDatePreviewFormat(from: releaseDate)
        self.generName = genderName
        self.voteAverage = voteAverage
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

extension TMDBBannerViewModel {
    static let placeholder = TMDBBannerViewModel(url: nil, title: "-", releaseDate: "-", genderName: "-", voteAverage: "0", onWatchlist: { _ in }, onFavorites: { _ in })
}
