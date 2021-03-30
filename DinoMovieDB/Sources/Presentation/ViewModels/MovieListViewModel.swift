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
    
    // MARK: Input
    let fetchUpcomingMoviesTrigger = PassthroughSubject<Void, Never>()
    let movieTap = PassthroughSubject<Int, Never>()
    
    // MARK: Ouput
    let fetchUpcomingMoviesPublisher = PassthroughSubject<Void, Never>()
    let movieSelectedPublisher = PassthroughSubject<Int, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    func setupBindings() {
        // Sets Publishers
        let fetchUpcomingMoviesTriggerPublisher = fetchUpcomingMoviesTrigger.receive(on: DispatchQueue.main)
        let movieTapPublisher = movieTap.receive(on: DispatchQueue.main)
        
        fetchUpcomingMoviesTriggerPublisher
            .sink(receiveValue: fetchUpcomingMoviesPublisher.send)
            .store(in: &cancellables)
        movieTapPublisher.sink(receiveValue: movieSelectedPublisher.send)
            .store(in: &cancellables)
    }
}
