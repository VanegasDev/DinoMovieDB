//
//  ItemDetailViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import Foundation
import Combine

class ItemDetailViewModel: ObservableObject, Identifiable {
    enum MediaType: String {
        case movies = "movie"
        case tvShows = "tv"
    }
    
    // MARK: Published
    @Published var isMarkedAsFavorite: Bool = false
    @Published var isOnWatchlist: Bool = false
    @Published var title: String
    @Published var releaseDate: String
    @Published var rate: String
    @Published var imageUrl: URL?
    @Published var isFavoriteButtonEnabled: Bool = true
    @Published var isWatchlistButtonEnabled: Bool = true
    
    // MARK: Properties
    private let service: ItemsServiceType = ItemsService()
    private let mediaType: MediaType
    let itemId: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    init(itemType: MediaType, itemId: Int, title: String, releaseDate: String, rate: String, imageUrl: URL?) {
        self.mediaType = itemType
        self.itemId = itemId
        self.title = title
        
        // Uses our custom formatter
        self.releaseDate = DateFormatter.tmdbDatePreviewFormat(from: releaseDate)
        self.rate = rate
        self.imageUrl = imageUrl
    }
    
    func markAsFavorite() {
        let params = FavoritesState(mediaType: mediaType.rawValue, itemId: itemId, isFavorite: !isMarkedAsFavorite)
        
        service.markAsFavorite(itemParams: params)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isFavoriteButtonEnabled = false
            })
            .sink { [weak self] in
                self?.isFavoriteButtonEnabled = true
            } onReceived: { [weak self] response in
                self?.isMarkedAsFavorite.toggle()
            }
            .store(in: &cancellables)
    }
    
    func addToWatchlist() {
        let param = WatchlistsState(mediaType: mediaType.rawValue, itemId: itemId, isOnWatchList: !isOnWatchlist)
        
        service.addToWatchList(itemParams: param)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isWatchlistButtonEnabled = false
            })
            .sink { [weak self] in
                self?.isWatchlistButtonEnabled = true
            } onReceived: { [weak self] response in
                self?.isOnWatchlist.toggle()
            }
            .store(in: &cancellables)
    }
    
    func fetchItemState() {
        fetchItemStateRequest()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isWatchlistButtonEnabled = false
                self?.isFavoriteButtonEnabled = false
            })
            .sink { [weak self] in
                self?.isWatchlistButtonEnabled = true
                self?.isFavoriteButtonEnabled = true
            } onReceived: { [weak self] itemState in
                self?.isMarkedAsFavorite = itemState.isFavorite
                self?.isOnWatchlist = itemState.isOnWatchlist
            }
            .store(in: &cancellables)
    }
    
    private func fetchItemStateRequest() -> AnyPublisher<ItemState, Error> {
        switch mediaType {
        case .movies:
            return service.fetchMoviesState(movieId: itemId)
        case .tvShows:
            return service.fetchTvShowsState(showId: itemId)
        }
    }
}
