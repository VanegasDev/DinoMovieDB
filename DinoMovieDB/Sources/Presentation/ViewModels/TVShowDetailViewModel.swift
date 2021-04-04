//
//  TVShowDetailViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/3/21.
//

import SwiftUI
import Combine

class TVShowDetailViewModel: ObservableObject {
    @Published var bannerViewModel: TMDBBannerViewModel = .placeholder
    @Published var creator: String = "-"
    @Published var duration: String = "0"
    @Published var overview: String = "No Description"
    @Published var cast: [CastPerson] = []
    @Published var seasons: [Season] = []
    @Published var isLoading = false
    
    // MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Input
    let fetchDetailsInput = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    let fetchDetailOutput = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    private func setupBindings() {
        let fetchDetailPublisher = fetchDetailsInput.receive(on: DispatchQueue.main)
        
        fetchDetailPublisher.handleEvents(receiveOutput: { [weak self] _ in self?.isLoading = true })
            .sink(onReceived: fetchDetailOutput.send).store(in: &cancellables)
    }
}
