//
//  ItemListViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/9/21.
//

import SwiftUI
import Combine

class ItemListViewModel: ObservableObject {
    // MARK: Published properties
    @Published var itemsViewModel: [ItemDetailViewModel] = []
    
    // MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Input
    let fetchItemsInput = PassthroughSubject<Void, Never>()
    let itemTapInput = PassthroughSubject<Int, Never>()
    
    // MARK: Output
    let fetchItemsOutput = PassthroughSubject<Void, Never>()
    let itemTapOutput = PassthroughSubject<Int, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    func setupBindings() {
        // Sets Publishers
        let fetchItemsPublisher = fetchItemsInput.receive(on: DispatchQueue.main)
        let itemTapPublisher = itemTapInput.receive(on: DispatchQueue.main)
        
        fetchItemsPublisher
            .sink(receiveValue: fetchItemsOutput.send)
            .store(in: &cancellables)
        itemTapPublisher
            .sink(onReceived: itemTapOutput.send)
            .store(in: &cancellables)
    }
}
