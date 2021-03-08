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
        
        addHosting(LoginView(viewModel: viewModel))
        setupBindings()
    }
    
    private func setupBindings() {
        let loginPublisher = viewModel.loginActionPublisher.receive(on: DispatchQueue.main)
        
        loginPublisher.sink(receiveValue: login).store(in: &cancellables)
    }
    
    private func login() {
        let username = viewModel.username
        let password = viewModel.password
        
        authenticationService.askForRequestToken()
            .flatMap { [weak self] requestToken -> AnyPublisher<SessionToken, Error> in
                guard let self = self else {
                    return Fail(error: TMDBError.selfNotFound).eraseToAnyPublisher()
                }
                
                let parameters = LoginParameters(username: username, password: password, requestToken: requestToken.token)
                return self.authenticationService.login(with: parameters)
            }
            .sink(receiveCompletion: { [weak self] response in
                switch response {
                case .failure(let error):
                    self?.viewModel.isLoading = false
                    self?.loginFailed(error)
                case .finished:
                    break
                }
            }) { [weak self] session in
                self?.viewModel.isLoading = false
                self?.successfulLogin(session: session)
            }
            .store(in: &cancellables)
    }
    
    private func loginFailed(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(action1)
        present(alertController, animated: true)
    }
    
    private func successfulLogin(session: SessionToken) {
        NotificationCenter.default.post(name: .loginNotification, object: nil)
    }
}
