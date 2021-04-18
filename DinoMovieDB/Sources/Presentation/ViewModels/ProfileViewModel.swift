//
//  ProfileViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/22/21.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    // MARK: Properties
    @Published var isLoading: Bool = false
    @Published var name: String = "Full Name"
    @Published var username: String = "username"
    @Published var avatarPath: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Input
    let fetchInformationInput = PassthroughSubject<Void, Never>()
    let showFavoritesInput = PassthroughSubject<Void, Never>()
    let logoutInput = PassthroughSubject<Void, Never>()
    let showWatchlistInput = PassthroughSubject<Void, Never>()
    let showRatingsInput = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    let fetchInformationOutput = PassthroughSubject<Void, Never>()
    let showFavoritesOutput = PassthroughSubject<Void, Never>()
    let logoutOutput = PassthroughSubject<Void, Never>()
    let showWatchlistOutput = PassthroughSubject<Void, Never>()
    let showRatingsOutput = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    private func setupBindings() {
        // Subscribe to publishers
        let fetchInformation = fetchInformationInput
            .receive(on: DispatchQueue.main)
        let logout = logoutInput.receive(on: DispatchQueue.main)
        let showFavoritesPublisher = showFavoritesInput.receive(on: DispatchQueue.main)
        let showWatchlistPublisher = showWatchlistInput.receive(on: DispatchQueue.main)
        let showRatingsPublisher = showRatingsInput.receive(on: DispatchQueue.main)
        
        // Handle Events
        fetchInformation.handleEvents(receiveOutput: { [weak self] _ in self?.isLoading = true })
            .sink(onReceived: fetchInformationOutput.send)
            .store(in: &cancellables)
        logout.sink(onReceived: logoutOutput.send).store(in: &cancellables)
        showFavoritesPublisher
            .sink(onReceived: showFavoritesOutput.send)
            .store(in: &cancellables)
        showWatchlistPublisher
            .sink(onReceived: showWatchlistOutput.send)
            .store(in: &cancellables)
        showRatingsPublisher
            .sink(onReceived: showRatingsOutput.send)
            .store(in: &cancellables)
    }
    
    // MARK: Functionality
    func receivedUserInformation(_ information: MyAccount) {
        username = information.username
        name = information.name
        avatarPath = "\(TMDBConfiguration.imageBasePath)\(information.avatar?.tmdbAvatarInformation.path ?? "")"
    }
}
