//
//  TMDBMainCoordinator.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/7/21.
//

import UIKit
import Combine

protocol MainCoordinatorType {
    var window: UIWindow { get set }
    func setupCoordinator()
    func startOnCurrentState()
}

class TMDBMainCoordinator: MainCoordinatorType {
    private var cancellables = Set<AnyCancellable>()
    var window: UIWindow
    
    init(window: UIWindow = TMDBWindow(frame: UIScreen.main.bounds)) {
        self.window = window
        setupCoordinator()
    }
    
    func setupCoordinator() {
        let loginPublisher = NotificationCenter.default.publisher(for: .loginNotification).receive(on: DispatchQueue.main)
        let logoutPublisher = NotificationCenter.default.publisher(for: .logoutNotification).receive(on: DispatchQueue.main)
        
        loginPublisher.sink { [weak self] _ in
            guard let tmdbWindow = self?.window as? TMDBWindow else { return }
            
            tmdbWindow.start(on: .logged)
        }
        .store(in: &cancellables)
        
        logoutPublisher.sink { [weak self] _ in
            guard let tmdbWindow = self?.window as? TMDBWindow else { return }
            
            tmdbWindow.start(on: .logout)
        }
        .store(in: &cancellables)
    }
    
    func startOnCurrentState() {
        let currentState: Notification.Name = SessionToken.get(from: .keychainSwift) == nil ? .logoutNotification : .loginNotification
        NotificationCenter.default.post(name: currentState, object: nil)
    }
}
