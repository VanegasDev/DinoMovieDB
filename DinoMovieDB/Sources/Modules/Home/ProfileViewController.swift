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
        let fetchInformationPublisher = viewModel.fetchInformationOutput.receive(on: DispatchQueue.main)
        let logoutPublisher = viewModel.logoutOutput.receive(on: DispatchQueue.main)
        let showFavoritesPublisher = viewModel.showFavoritesOutput.receive(on: DispatchQueue.main)
        let showWatchlistPublisher = viewModel.showFavoritesOutput.receive(on: DispatchQueue.main)
        let showRatingsPublisher = viewModel.showFavoritesOutput.receive(on: DispatchQueue.main)
        
        // Publisher Handler
        fetchInformationPublisher.sink { [weak self] in self?.fetchInformation() }.store(in: &cancellables)
        logoutPublisher.sink(receiveValue: showLogoutAlert).store(in: &cancellables)
        showFavoritesPublisher.sink(onReceived: showFavoritesViewController).store(in: &cancellables)
        showWatchlistPublisher.sink(onReceived: showWatchlistViewController).store(in: &cancellables)
        showRatingsPublisher.sink(onReceived: showRatingsViewController).store(in: &cancellables)
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
    
    // MARK: Functionality
    private func showFavoritesViewController() {
        navigationController?.pushViewController(MyFavoritesViewController(), animated: true)
    }
    
    private func showWatchlistViewController() {
        navigationController?.pushViewController(MyWatchlistViewController(), animated: true)
    }
    
    private func showRatingsViewController() {
        navigationController?.pushViewController(MyFavoritesViewController(), animated: true)
    }
    
    private func logout() {
        accountService.logout()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController.customAlert(title: R.string.localization.profile_sign_out_alert_title(),
                                                  description: R.string.localization.profile_sign_out_alert_description(),
                                                  yesTitle: R.string.localization.alert_yes_button(),
                                                  noTitle: R.string.localization.alert_no_button(),
                                                  yesAction: { [weak self] _ in self?.logout() })
        
        present(alert, animated: true)
    }
}
