//
//  MoyaRequester.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Foundation
import Combine
import Moya

typealias NetworkResponse = (data: Data, httpResponse: HTTPURLResponse?)
typealias DecodedResponse<T: Decodable> = (response: T, httpResponse: HTTPURLResponse?)

// MARK: Requester Protocol
protocol MoyaRequesterType {
    func request(target: TargetType) -> AnyPublisher<NetworkResponse, MoyaError>
}

// MARK: Decoded Response
extension MoyaRequesterType {
    func request<T: Decodable>(target: TargetType, with decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<DecodedResponse<T>, Error> {
        request(target: target)
            .tryMap { response in
                let result = try decoder.decode(T.self, from: response.data)
                return (response: result, httpResponse: response.httpResponse)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: Moya Requester
struct MoyaRequester: MoyaRequesterType {
    private let provider: MoyaProvider<MultiTarget>
    
    init(with provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    func request(target: TargetType) -> AnyPublisher<NetworkResponse, MoyaError> {
        Future { promise in
            provider.request(MultiTarget(target)) { networkResponse in
                switch networkResponse {
                case .success(let response):
                    let result = (data: response.data, httpResponse: response.response)
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

