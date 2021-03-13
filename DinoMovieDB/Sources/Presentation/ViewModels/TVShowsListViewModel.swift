//
//  TVShowsListViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import SwiftUI
import Combine

class TVShowsListViewModel: ObservableObject {
    // State properties
    @Published var showsViewModel: [ItemDetailViewModel] = []
    
    // Propiedades
    private var cancellables = Set<AnyCancellable>()
    
    let fetchPopularShowsTrigger = PassthroughSubject<Void, Never>()
    let fetchPopularShowsPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    func setupBindings() {
        // Setear Publishers
        let fetchPopularShowsTriggerPublisher = fetchPopularShowsTrigger.receive(on: DispatchQueue.main)
        
        fetchPopularShowsTriggerPublisher
            .sink(receiveValue: fetchPopularShowsPublisher.send)
            .store(in: &cancellables)
    }
}
