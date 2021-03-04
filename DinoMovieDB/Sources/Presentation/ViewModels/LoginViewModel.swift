//
//  LoginViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/4/21.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    let loginButtonTap = PassthroughSubject<Void, Never>()
    let loginActionPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    private func setupBindings() {
        let loginButtonTapPublisher = loginButtonTap.receive(on: DispatchQueue.main)
        
        loginButtonTapPublisher
            .sink(receiveValue: loginActionPublisher.send)
            .store(in: &cancellables)
    }
}
