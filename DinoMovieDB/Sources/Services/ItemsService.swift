//
//  ItemsService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/24/21.
//

import Foundation
import Combine
import Moya

// MARK: Protocol Definition for Items Service
protocol ItemsServiceType {
    func markAsFavorite(itemParams: FavoritesState) -> AnyPublisher<NetworkResponse, Error>
    func addToWatchList(itemParams: WatchlistsState) -> AnyPublisher<NetworkResponse, Error>
    func fetchMoviesState(movieId: Int) -> AnyPublisher<ItemState, Error>
    func fetchTvShowsState(showId: Int) -> AnyPublisher<ItemState, Error>
}

// MARK: ItemServiceType Implementation
struct ItemsService: ItemsServiceType {
    // MARK: API Requester
    private let apiRequester: NetworkManagerType
    
    init(apiRequester: NetworkManagerType = NetworkManager()) {
        self.apiRequester = apiRequester
    }
    
    func markAsFavorite(itemParams: FavoritesState) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        let accountInformation = MyAccount.get(from: .keychainSwift)
        
        return apiRequester.request(AccountTarget.markAsFavorite(accountId: accountInformation?.id ?? 0, params: itemParams, session: sessionToken))
    }
    
    func addToWatchList(itemParams: WatchlistsState) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        let accountInformation = MyAccount.get(from: .keychainSwift)
        
        return apiRequester.request(AccountTarget.addToWatchlist(accountId: accountInformation?.id ?? 0, params: itemParams, session: sessionToken))
    }
    
    func fetchMoviesState(movieId: Int) -> AnyPublisher<ItemState, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(MoviesTarget.fetchMovieState(movieId: movieId, session: sessionToken))
    }
    
    func fetchTvShowsState(showId: Int) -> AnyPublisher<ItemState, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(TVShowsTarget.fetchShowState(showId: showId, session: sessionToken))
    }
}
