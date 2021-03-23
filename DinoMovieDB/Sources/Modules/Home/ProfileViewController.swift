//
//  ProfileViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/19/21.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    private let accountService: AccountServiceType = AccountService()
    private let viewModel = ProfileViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Setup
    private func setupViews() {
        title = R.string.localization.profile_title()
        
        addHosting(ProfileView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        // Subcribe to viewmodel publishers
        let fetchInformationPublisher = viewModel.fetchInformationPublisher.receive(on: DispatchQueue.main)
        let logoutPublisher = viewModel.logoutTapPublisher.receive(on: DispatchQueue.main)
        
        // Publisher Handler
        fetchInformationPublisher.sink { [weak self] in self?.fetchInformation() }.store(in: &cancellables)
        logoutPublisher.sink { [weak self] in self?.accountService.logout() }.store(in: &cancellables)
    }
    
    // MARK: Service Request
    private func fetchInformation() {
        let informationPublisher = accountService.fetchMyAccountInformation().receive(on: DispatchQueue.main)
        
        informationPublisher.sink { [weak self] in
            self?.viewModel.isLoading = false
        } error: { [weak self] error in
            let alert = UIAlertController.errorAlert(description: error.localizedDescription)
            
            self?.present(alert, animated: true)
        } onReceived: { [weak self] information in
            self?.viewModel.receivedUserInformation(information)
        }
        .store(in: &cancellables)
    }
}
