//
//  MoviesService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/9/21.
//

import Foundation
import Combine
import Moya

// Movies request service protocol
protocol MoviesServiceType {
    func fetchUpcomingMovies(page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error>
    func search(movie: String, on page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error>
    func fetchFavoriteMovies(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[MoviePreview]>, Error>
    func fetchWatchlistMovies(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[MoviePreview]>, Error>
    func fetchRatedMovies(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[MoviePreview]>, Error>
}

// Defines a default behavior for fetchUpcomingMovies function
extension MoviesServiceType {
    func fetchUpcomingMovies(page: Int = 1) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        fetchUpcomingMovies(page: page)
    }
}

// Movies Services class implementing the Movies Service Protocol
struct MoviesService: MoviesServiceType {
    // MARK: API Requester
    private let apiRequester: NetworkManagerType
    
    init(apiRequester: NetworkManagerType = NetworkManager()) {
        self.apiRequester = apiRequester
    }
    
    // Fetches upcoming movies
    func fetchUpcomingMovies(page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        apiRequester.request(MoviesTarget.latest(page: page))
    }
    
    // Searches movies
    func search(movie: String, on page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        apiRequester.request(MoviesTarget.search(movie: movie, page: page))
    }
    
    // Fetches favorites movies
    func fetchFavoriteMovies(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        let session = SessionToken.get(from: .keychainSwift)
        let userInformation = MyAccount.get(from: .keychainSwift)
        
        return apiRequester.request(MoviesTarget.fetchFavoriteMovies(accountId: userInformation?.id ?? 0, session: session, page: page, sortedBy: sortedBy.queryParam))
    }
    
    // Fetches watchlist movies
    func fetchWatchlistMovies(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        let session = SessionToken.get(from: .keychainSwift)
        let userInformation = MyAccount.get(from: .keychainSwift)
        
        return apiRequester.request(MoviesTarget.fetchWatchlistMovies(accountId: userInformation?.id ?? 0, session: session, page: page, sortedBy: sortedBy.queryParam))
    }
    
    // Fetches rated movies
    func fetchRatedMovies(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        let session = SessionToken.get(from: .keychainSwift)
        let userInformation = MyAccount.get(from: .keychainSwift)
        
        return apiRequester.request(MoviesTarget.fetchRatedMovies(accountId: userInformation?.id ?? 0, session: session, page: page, sortedBy: sortedBy.queryParam))
    }
}
