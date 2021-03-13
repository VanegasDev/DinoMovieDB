//
//  LoginViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/4/21.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private let authenticationService: AuthenticationServiceType = AuthenticationService()
    private let viewModel = LoginViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    // MARK: Setup
    private func setupViews() {
        view.backgroundColor = R.color.backgroundColor()
        addHosting(LoginView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        let loginPublisher = viewModel.loginActionPublisher.receive(on: DispatchQueue.main)
        
        loginPublisher.sink(receiveValue: login).store(in: &cancellables)
    }
    
    private func login() {
        let username = viewModel.username
        let password = viewModel.password
        
        // Ask for Request Token
        authenticationService.askForRequestToken()
            .flatMap { [weak self] requestToken -> AnyPublisher<SessionToken, Error> in
                guard let self = self else {
                    return Fail(error: TMDBError.selfNotFound).eraseToAnyPublisher()
                }
                
                // Creates Session
                let parameters = LoginParameters(username: username, password: password, requestToken: requestToken.token)
                return self.authenticationService.login(with: parameters)
            }
            .sink(error: { [weak self] error in
                // Shows Error Alert
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)
                
                self?.viewModel.isLoading = false
                self?.present(alert, animated: true)
            }) { [weak self] session in
                // Receives Session
                self?.viewModel.isLoading = false
                self?.successfulLogin(session: session)
            }
            .store(in: &cancellables)
    }
    
    private func successfulLogin(session: SessionToken) {
        NotificationCenter.default.post(name: .loginNotification, object: nil)
    }
}
