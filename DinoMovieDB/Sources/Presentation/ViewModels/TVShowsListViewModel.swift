//
//  TVShowsListViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import SwiftUI
import Combine

class TVShowsListViewModel: ObservableObject {
    // MARK: Published properties
    @Published var showsViewModel: [ItemDetailViewModel] = []
    
    // MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Inputs
    let fetchPopularShowsInput = PassthroughSubject<Void, Never>()
    let selectShowInput = PassthroughSubject<Int, Never>()
    
    // MARK: Outputs
    let fetchPopularShowsOutput = PassthroughSubject<Void, Never>()
    let selectShowOutput = PassthroughSubject<Int, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    func setupBindings() {
        // Sets Publishers
        let fetchPopularShowsTriggerPublisher = fetchPopularShowsInput.receive(on: DispatchQueue.main)
        let selectShowPublisher = selectShowInput.receive(on: DispatchQueue.main)
        
        fetchPopularShowsTriggerPublisher
            .sink(receiveValue: fetchPopularShowsOutput.send)
            .store(in: &cancellables)
        selectShowPublisher
            .sink(onReceived: selectShowOutput.send)
            .store(in: &cancellables)
    }
}
