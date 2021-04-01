//
//  RateMovieViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/31/21.
//

import SwiftUI
import Combine

class RateItemViewModel: ObservableObject {
    @Published var isItemRated = false
    @Published var ratingValue: Int = 0
    @Published var isLoading: Bool = false
    
    // MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    let itemId: Int
    let itemName: String
    
    // MARK: Input
    let onAppearInputPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    let rateOutputPublisher = PassthroughSubject<Void, Never>()
    let deleteRateOutputPublisher = PassthroughSubject<Void, Never>()
    let onAppearOutputPublisher = PassthroughSubject<Void, Never>()
    
    init(itemId: Int, itemName: String) {
        self.itemId = itemId
        self.itemName = itemName
        
        setupBindings()
    }
    
    // MARK: Setup
    private func setupBindings() {
        let ratePublisher = $ratingValue.receive(on: DispatchQueue.main)
        let onAppearPublisher = onAppearInputPublisher.receive(on: DispatchQueue.main)
        
        ratePublisher
            .dropFirst(2)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in self?.isLoading = true })
            .sink { [weak self] value in
                guard value == 0 else {
                    self?.rateOutputPublisher.send(())
                    return
                }
                
                self?.deleteRateOutputPublisher.send(())
            }
            .store(in: &cancellables)
        onAppearPublisher.handleEvents(receiveOutput: { [weak self] _ in self?.isLoading = true })
            .sink(onReceived: onAppearOutputPublisher.send)
            .store(in: &cancellables)
    }
}
