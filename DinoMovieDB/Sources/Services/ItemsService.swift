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
    func rate(movieId: Int, rating value: Int) -> AnyPublisher<NetworkResponse, Error>
    func rate(showId: Int, rating value: Int) -> AnyPublisher<NetworkResponse, Error>
    func deleteRateOn(movieId: Int) -> AnyPublisher<NetworkResponse, Error>
    func deleteRateOn(showId: Int) -> AnyPublisher<NetworkResponse, Error>
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
    
    func rate(movieId: Int, rating value: Int) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        let rate = Rate(value: Double(value * 2))
        
        return apiRequester.request(MoviesTarget.rate(movieId: movieId, rate: rate, session: sessionToken))
    }
    
    func rate(showId: Int, rating value: Int) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        let rate = Rate(value: Double(value * 2))
        
        return apiRequester.request(TVShowsTarget.rate(showId: showId, rate: rate, session: sessionToken))
    }
    
    func deleteRateOn(showId: Int) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(TVShowsTarget.deleteRate(showId: showId, session: sessionToken))
    }
    
    func deleteRateOn(movieId: Int) -> AnyPublisher<NetworkResponse, Error> {
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        return apiRequester.request(MoviesTarget.deleteRate(movieId: movieId, session: sessionToken))
    }
}
