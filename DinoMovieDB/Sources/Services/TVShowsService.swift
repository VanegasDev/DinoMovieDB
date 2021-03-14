//
//  TVShowsService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import Foundation
import Combine
import Moya

//  TVShows Requests service protocol
protocol TVShowsServiceType {
    func fetchPopularShows(page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error>
}

// Defines default behavior to fetchPopularShows
extension TVShowsServiceType {
    func fetchPopularShows(page: Int = 1) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        fetchPopularShows(page: page)
    }
}

// TVShows service class implementing the TVShows protocol
struct TVShowsService: TVShowsServiceType {
    // API Requester
    private let apiRequester: MoyaRequesterType
    
    init(apiRequester: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.apiRequester = apiRequester
    }
    
    // Fetches popular tv shows
    func fetchPopularShows(page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        apiRequester.request(target: TVShowsTarget.popular(page: page))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
    
    // Searches TVShows
    func search(show: String, on page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        apiRequester.request(target: TVShowsTarget.search(show: show, page: page))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
