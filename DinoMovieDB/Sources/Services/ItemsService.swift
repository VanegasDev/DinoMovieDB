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
    private let apiRequester: MoyaRequesterType
    
    init(apiRequester: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.apiRequester = apiRequester
    }
    
    func markAsFavorite(itemParams: FavoritesState) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(target: AccountTarget.markAsFavorite(accountId: 9523333, params: itemParams, session: sessionToken))
    }
    
    func addToWatchList(itemParams: WatchlistsState) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(target: AccountTarget.addToWatchlist(accountId: 9523333, params: itemParams, session: sessionToken))
    }
    
    func fetchMoviesState(movieId: Int) -> AnyPublisher<ItemState, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(target: MoviesTarget.fetchMovieState(movieId: movieId, session: sessionToken))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
    
    func fetchTvShowsState(showId: Int) -> AnyPublisher<ItemState, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(target: TVShowsTarget.fetchShowState(showId: showId, session: sessionToken))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
