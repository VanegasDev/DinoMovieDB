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
    func logout()
}

// My Account Service Type implementation
class AccountService: AccountServiceType {
    // MARK: API Requester
    private let apiRequester: NetworkManagerType
    private var cancellables = Set<AnyCancellable>()
    
    init(apiRequester: NetworkManagerType = NetworkManager()) {
        self.apiRequester = apiRequester
    }
    
    // Function to fetch user account information
    func fetchMyAccountInformation() -> AnyPublisher<MyAccount, Error> {
        // Gets session token from keychain
        let sessionToken = SessionToken.get(from: .keychainSwift)
        
        // Make request
        return fetchUserInformationFromCache()
            .catch { [weak self] _ -> AnyPublisher<MyAccount, Error> in
                guard let self = self else { return Fail(error: TMDBError.selfNotFound).eraseToAnyPublisher() }
                return self.fetchUserInformationFromAPI(sessionToken: sessionToken).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func logout() {
        // Close session on API
        let sessionToken = SessionToken.get(from: .keychainSwift)
        apiRequester.request(AccountTarget.logout(session: sessionToken))
            .sink {
                // Close session locally
                MyAccount.remove(from: .keychainSwift)
                SessionToken.remove(from: .keychainSwift)
                NotificationCenter.default.post(name: .logoutNotification, object: nil)
            } onReceived: { _ in }
            .store(in: &cancellables)
    }
    
    private func fetchUserInformationFromAPI(sessionToken: SessionToken?) -> AnyPublisher<MyAccount, Error> {
        apiRequester.request(AccountTarget.information(session: sessionToken))
            .map { (apiResponse: DecodedResponse<MyAccount>) -> MyAccount in
                let information = apiResponse.response
                try? information.save(on: .keychainSwift)
                
                return information
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchUserInformationFromCache() -> AnyPublisher<MyAccount, Error> {
        Future { seal in
            guard let information = MyAccount.get(from: .keychainSwift) else {
                seal(.failure(TMDBError.cachedValueNotFound))
                return
            }
            
            seal(.success(information))
        }.eraseToAnyPublisher()
    }
}
