//
//  AuthenticationService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/4/21.
//

import Foundation
import Combine
import Moya

// Authentication Protocol to Handle all Kind of Authetication Requests
protocol AuthenticationServiceType: class {
    func askForRequestToken() -> AnyPublisher<RequestToken, Error>
    func login(with parameters: LoginParameters) -> AnyPublisher<SessionToken, Error>
}

// Authentication Service Implementing my Auth Protocol
class AuthenticationService: AuthenticationServiceType {
    // API Requester
    private let apiRequester: MoyaRequesterType
    
    init(apiRequester: MoyaRequesterType = MoyaRequester(with: MoyaProvider())) {
        self.apiRequester = apiRequester
    }
    
    // Asks for request token
    func askForRequestToken() -> AnyPublisher<RequestToken, Error> {
        apiRequester.request(target: AuthenticationTarget.requestToken)
            .map { $0.response }
            .eraseToAnyPublisher()
    }
    
    // Login Request
    func login(with parameters: LoginParameters) -> AnyPublisher<SessionToken, Error> {
        apiRequester.request(target: AuthenticationTarget.login(parameters: parameters))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
