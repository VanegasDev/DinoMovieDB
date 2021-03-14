//
//  PaginationManager.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/10/21.
//

import Foundation
import Combine

enum PaginationState {
    case isPaginating
    case readyForPagination
}

// Pagination Protocol
protocol PaginationManagerType: class {
    var state: PaginationState { get set }
    var nextPage: Int? { get }
    
    func paginate<T: Decodable>(request: () -> AnyPublisher<APIResponse<T>, Error>) -> AnyPublisher<T, Error>
    func resetPagination()
}

// PaginationManager
class PaginationManager: PaginationManagerType {
    // Properties
    private var totalPages: Int = 1
    private var currentPage: Int = 0
    
    // Pagination State
    var state: PaginationState = .readyForPagination
    
    // Returns the next page and if there is no next page it will returns nil
    var nextPage: Int? {
        currentPage < totalPages ? currentPage + 1 : nil
    }
    
    func paginate<T>(request: () -> AnyPublisher<APIResponse<T>, Error>) -> AnyPublisher<T, Error> where T : Decodable {
        // Notifies that is paginating
        state = .isPaginating
        
        // Make request
        return request()
            .map { [weak self] response in
                // Gets the pagination information
                self?.totalPages = response.totalPages
                self?.currentPage = response.page
                
                return response.results
            }
            .eraseToAnyPublisher()
    }
    
    func resetPagination() {
        totalPages = 1
        currentPage = 0
    }
}
