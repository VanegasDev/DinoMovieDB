//
//  MoviesService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/9/21.
//

import Foundation
import Combine
import Moya

// Protocolo Para Manejar Request de Peliculas
protocol MoviesServiceType {
    func fetchUpcomingMovies(page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error>
}

// Extension para definir un default behavior en los objetos que implementen este protocolo
extension MoviesServiceType {
    func fetchUpcomingMovies(page: Int = 1) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        fetchUpcomingMovies(page: page)
    }
}

// Mi Servicio Para Hacer de Peliculas
struct MoviesService: MoviesServiceType {
    // API Requester
    private let apiRequester: MoyaRequesterType
    
    init(apiRequester: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.apiRequester = apiRequester
    }
    
    // Metodo para descargar las proximas peliculas
    func fetchUpcomingMovies(page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        apiRequester.request(target: MoviesTarget.latest(page: page))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
