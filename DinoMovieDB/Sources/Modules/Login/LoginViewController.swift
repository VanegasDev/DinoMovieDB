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
        authenticationService.askForRequestToken()
            .sink(receiveCompletion: { response in
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                }
            }) { token in
                print("TOKEN: \(token)")
            }
            .store(in: &cancellables)
    }
}
