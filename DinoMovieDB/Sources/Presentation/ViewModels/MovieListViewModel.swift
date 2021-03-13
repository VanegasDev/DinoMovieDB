//
//  MovieListViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/7/21.
//

import SwiftUI
import Combine

class MovieListViewModel: ObservableObject {
    // MARK: Published properties
    @Published var moviesViewModel: [ItemDetailViewModel] = []
    
    // MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    
    let fetchUpcomingMoviesTrigger = PassthroughSubject<Void, Never>()
    let fetchUpcomingMoviesPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    func setupBindings() {
        // Sets Publishers
        let fetchUpcomingMoviesTriggerPublisher = fetchUpcomingMoviesTrigger.receive(on: DispatchQueue.main)
        
        fetchUpcomingMoviesTriggerPublisher
            .sink(receiveValue: fetchUpcomingMoviesPublisher.send)
            .store(in: &cancellables)
    }
}
