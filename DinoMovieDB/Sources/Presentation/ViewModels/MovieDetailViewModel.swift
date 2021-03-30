//
//  MovieDetailViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/28/21.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    // MARK: Properties
    @Published var bannerViewModel: TMDBBannerViewModel = .placeholder
    @Published var directorName: String = "-"
    @Published var duration: String = "0"
    @Published var overview: String = "No Description"
    @Published var cast: [CastPerson] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Input
    let fetchDetailsTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    let fetchDetailsTriggerPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        let fetchDetailsPublisher = fetchDetailsTrigger.receive(on: DispatchQueue.main)
        
        fetchDetailsPublisher.handleEvents(receiveOutput: { [weak self] _ in self?.isLoading = true })
            .sink(onReceived: fetchDetailsTriggerPublisher.send)
            .store(in: &cancellables)
    }
}
