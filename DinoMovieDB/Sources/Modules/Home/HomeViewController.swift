//
//  HomeViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import UIKit
import Combine

enum HomeTabs: Int {
    case movies
    case tvShows
    case profile
    
    var viewController: UIViewController {
        let viewController: UIViewController
        
        switch self {
        case .movies:
            viewController = MovieListViewController()
            viewController.tabBarItem = UITabBarItem(title: R.string.localization.movie_list_title(), image: UIImage(systemName: "film"), tag: 0)
        case .tvShows:
            viewController = TVShowsListViewController()
            viewController.tabBarItem = UITabBarItem(title: R.string.localization.tv_shows_list_title(), image: UIImage(systemName: "tv"), tag: 1)
        case .profile:
            viewController = ProfileViewController()
            viewController.tabBarItem = UITabBarItem(title: R.string.localization.profile_title(), image: UIImage(systemName: "person"), tag: 2)
        }
        
        return viewController
    }
}

class HomeViewController: UITabBarController {
    private let service: AccountServiceType = AccountService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchUserInformation()
    }
    
    // MARK: Setup
    private func setupViews() {
        let moviesViewController = UINavigationController(rootViewController: HomeTabs.movies.viewController)
        let tvShowsViewController = UINavigationController(rootViewController: HomeTabs.tvShows.viewController)
        let profileViewController = UINavigationController(rootViewController: HomeTabs.profile.viewController)
        tabBar.tintColor = R.color.primaryColor()
        
        setViewControllers([moviesViewController, tvShowsViewController, profileViewController], animated: true)
    }
    
    // MARK: Functionality
    private func fetchUserInformation() {
        service.fetchMyAccountInformation()
            .sink { _ in }
            .store(in: &cancellables)
    }
}
