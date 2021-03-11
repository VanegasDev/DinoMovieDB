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

// Protocol para paginacion
protocol PaginationManagerType: class {
    var state: PaginationState { get set }
    var nextPage: Int? { get }
    
    func paginate<T: Decodable>(request: () -> AnyPublisher<APIResponse<T>, Error>) -> AnyPublisher<T, Error>
}

// PaginationManager
class PaginationManager: PaginationManagerType {
    // Propiedades
    private var totalPages: Int = 1
    private var currentPage: Int = 0
    
    // Te da el state de la paginacion
    var state: PaginationState = .readyForPagination
    
    // Te da el numero de la siguiente pagina
    var nextPage: Int? {
        currentPage < totalPages ? currentPage + 1 : nil
    }
    
    func paginate<T>(request: () -> AnyPublisher<APIResponse<T>, Error>) -> AnyPublisher<T, Error> where T : Decodable {
        // Se notifica que esta paginando
        state = .isPaginating
        
        // Hace el request
        return request()
            .map { [weak self] response in
                // Obtenemos el total de paginas y actualizamos la pagina actual
                self?.totalPages = response.totalPages
                self?.currentPage = response.page
                
                return response.results
            }
            .eraseToAnyPublisher()
    }
}
