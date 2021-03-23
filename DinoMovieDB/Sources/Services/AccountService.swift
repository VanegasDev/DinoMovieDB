//
//  AccountService.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/22/21.
//

import Foundation
import Combine
import Moya

// Accounts Service protocol to get the user account information
protocol AccountServiceType {
    func fetchMyAccountInformation() -> AnyPublisher<MyAccount, Error>
}

// My Account Service Type implementation
struct AccountService: AccountServiceType {
    // Moya Network Requester
    private let apiRequester: MoyaRequesterType
    
    // Function to fetch user account information
    func fetchMyAccountInformation() -> AnyPublisher<MyAccount, Error> {
        // Gets session token from keychain
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        // Make request
        return apiRequester.request(target: AccountTarget.information(session: sessionToken))
            .map { $0.response }
            .eraseToAnyPublisher()
    }
}
