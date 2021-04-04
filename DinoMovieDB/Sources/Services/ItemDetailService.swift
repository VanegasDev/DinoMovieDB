//
//  ItemDetailServiceType.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/28/21.
//

import Foundation
import Combine

// MARK: ItemDetailServiceType protocol
protocol ItemDetailServiceType {
    func fetchDetailOfMovie(id: Int, appendToRequest: String?) -> AnyPublisher<MovieDetail, Error>
    func fetchDetailOfTVShow(id: Int, appendToRequest: String?) -> AnyPublisher<ShowDetail, Error>
}

// MARK: ItemDetailServiceType Implementation
struct ItemDetailService: ItemDetailServiceType {
    // MARK: API Requester
    private let apiRequester: NetworkManagerType
    
    init(apiRequester: NetworkManagerType = NetworkManager()) {
        self.apiRequester = apiRequester
    }
    
    func fetchDetailOfMovie(id: Int, appendToRequest: String?) -> AnyPublisher<MovieDetail, Error> {
        apiRequester.request(MoviesTarget.fetchMovieDetail(movieId: id, appendToResponse: appendToRequest))
    }
    
    func fetchDetailOfTVShow(id: Int, appendToRequest: String?) -> AnyPublisher<ShowDetail, Error> {
        apiRequester.request(TVShowsTarget.fetchShowDetail(showId: id, appendToResponse: appendToRequest))
    }
}
