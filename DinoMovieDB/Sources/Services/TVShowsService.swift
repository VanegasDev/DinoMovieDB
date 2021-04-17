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
    func search(show: String, on page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error>
    func fetchFavoriteShows(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error>
}

// Defines default behavior to fetchPopularShows
extension TVShowsServiceType {
    func fetchPopularShows(page: Int = 1) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        fetchPopularShows(page: page)
    }
}

// TVShows service class implementing the TVShows protocol
struct TVShowsService: TVShowsServiceType {
    // MARK: API Requester
    private let apiRequester: NetworkManagerType
    
    init(apiRequester: NetworkManagerType = NetworkManager()) {
        self.apiRequester = apiRequester
    }
    
    // Fetches popular tv shows
    func fetchPopularShows(page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        apiRequester.request(TVShowsTarget.popular(page: page))
    }
    
    // Searches TVShows
    func search(show: String, on page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        apiRequester.request(TVShowsTarget.search(show: show, page: page))
    }
    
    // Fetches favorite shows
    func fetchFavoriteShows(on page: Int, sortedBy: SortType) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        let session = SessionToken.get(from: .keychainSwift)
        let userInformation = MyAccount.get(from: .keychainSwift)
        
        return apiRequester.request(TVShowsTarget.fetchFavoriteShows(accountId: userInformation?.id ?? 0, session: session, page: page, sortedBy: sortedBy.queryParam))
    }
}
