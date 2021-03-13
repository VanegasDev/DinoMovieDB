//
//  Publisher+Extension.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/10/21.
//

import Combine

extension Publisher {
    // Custom Sink Operator
    func sink(response: (() -> Void)? = nil, error: ((Error) -> Void)? = nil, success: (() -> Void)? = nil, onReceived: @escaping (Output) -> Void) -> AnyCancellable {
        self.sink(receiveCompletion: { result in
            response?()
            
            switch result {
            case .failure(let errorResponse):
                error?(errorResponse)
            case .finished:
                success?()
            }
        }) { response in
            onReceived(response)
        }
    }
}
