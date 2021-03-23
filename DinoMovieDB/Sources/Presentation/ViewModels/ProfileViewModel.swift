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
    var fetchInformationOnAppear = PassthroughSubject<Void, Never>()
    var logoutTap = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    var fetchInformationPublisher = PassthroughSubject<Void, Never>()
    var logoutTapPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    // MARK: Setup
    private func setupBindings() {
        // Subscribe to publishers
        let fetchInformation = fetchInformationOnAppear
            .receive(on: DispatchQueue.main)
        let logout = logoutTap.receive(on: DispatchQueue.main)
        
        // Handle Events
        fetchInformation.handleEvents(receiveOutput: { [weak self] _ in self?.isLoading = true })
            .sink(onReceived: fetchInformationPublisher.send)
            .store(in: &cancellables)
        logout.sink(onReceived: logoutTapPublisher.send).store(in: &cancellables)
    }
    
    // MARK: Functionality
    func receivedUserInformation(_ information: MyAccount) {
        username = information.username
        name = information.name
        avatarPath = "\(TMDBConfiguration.imageBasePath)\(information.avatar?.tmdbAvatarInformation.path ?? "")"
    }
}
