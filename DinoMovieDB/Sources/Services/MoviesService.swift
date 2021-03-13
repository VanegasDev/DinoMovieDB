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
}

// Defines a default behavior for fetchUpcomingMovies function
extension MoviesServiceType {
    func fetchUpcomingMovies(page: Int = 1) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        fetchUpcomingMovies(page: page)
    }
}

// Movies Services class implementing the Movies Service Protocol
struct MoviesService: MoviesServiceType {
    // API Requester
    private let apiRequester: MoyaRequesterType
    
    init(apiRequester: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.apiRequester = apiRequester
    }
    
    // Fetches upcoming movies
    func fetchUpcomingMovies(page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        apiRequester.request(target: MoviesTarget.latest(page: page))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
