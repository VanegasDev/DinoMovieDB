//
//  MoyaRequester.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Foundation
import Combine
import Moya

// MARK: Requester Protocol
protocol MoyaRequesterType {
    func request(target: TargetType) -> AnyPublisher<NetworkResponse, Error>
}

// MARK: Moya Requester
struct MoyaRequester: MoyaRequesterType {
    private let provider: MoyaProvider<MultiTarget>
    
    init(with provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    func request(target: TargetType) -> AnyPublisher<NetworkResponse, Error> {
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

