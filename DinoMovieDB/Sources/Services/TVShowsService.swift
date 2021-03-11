//
//  TVShowsService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import Foundation
import Combine
import Moya

// Protocolo Para Manejar Request de TVShows
protocol TVShowsServiceType {
    func fetchPopularShows(page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error>
}

// Extension para definir un default behavior en los objetos que implementen este protocolo
extension TVShowsServiceType {
    func fetchPopularShows(page: Int = 1) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        fetchPopularShows(page: page)
    }
}

// Mi Servicio Para Hacer de TVShows
struct TVShowsService: TVShowsServiceType {
    // API Requester
    private let apiRequester: MoyaRequesterType
    
    init(apiRequester: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.apiRequester = apiRequester
    }
    
    // Metodo para descargar las proximas tv shows
    func fetchPopularShows(page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        apiRequester.request(target: TVShowsTarget.popular(page: page))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
