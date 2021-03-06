//
//  AuthenticationService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/4/21.
//

import Foundation
import Combine
import Moya

protocol AuthenticationServiceType: class {
    func askForRequestToken() -> AnyPublisher<RequestToken, Error>
    func login(with parameters: LoginParameters) -> AnyPublisher<SessionToken, Error>
}

class AuthenticationService: AuthenticationServiceType {
    private let apiRequester: MoyaRequesterType
    
    init(apiRequester: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.apiRequester = apiRequester
    }
    
    func askForRequestToken() -> AnyPublisher<RequestToken, Error> {
        apiRequester.request(target: AuthenticationTarget.requestToken)
            .map { $0.response }
            .eraseToAnyPublisher()
    }
    
    func login(with parameters: LoginParameters) -> AnyPublisher<SessionToken, Error> {
        apiRequester.request(target: AuthenticationTarget.login(parameters: parameters))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
