//
//  NetworkManager.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/26/21.
//

import Foundation
import Combine
import Moya

typealias NetworkResponse = (data: Data, httpResponse: HTTPURLResponse?)
typealias DecodedResponse<T: Decodable> = (response: T, httpResponse: HTTPURLResponse?)

// MARK: Network Manager Type Protocol
protocol NetworkManagerType {
    func request(_ target: TMDBTargetType) -> AnyPublisher<NetworkResponse, Error>
}

// MARK: Network Manager Type Implementation
struct NetworkManager: NetworkManagerType {
    private let provider: MoyaRequesterType
    
    init(with provider: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.provider = provider
    }
    
    func request(_ target: TMDBTargetType) -> AnyPublisher<NetworkResponse, Error> {
        provider.request(target: target)
    }
}

// MARK: Extension for Decoded Response
extension MoyaRequesterType {
    func request<T: Decodable>(target: TMDBTargetType, with decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        request(target: target)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(target: TMDBTargetType, with decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<DecodedResponse<T>, Error> {
        request(target: target)
            .tryMap { response in
                let result = try decoder.decode(T.self, from: response.data)
                return (response: result, httpResponse: response.httpResponse)
            }
            .eraseToAnyPublisher()
    }
}
