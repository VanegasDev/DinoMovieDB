//
//  HomeViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import UIKit

enum HomeTabs: Int {
    case movies
    case tvShows
    case profile
    
    var viewController: UIViewController {
        let viewController: UIViewController
        
        switch self {
        case .movies:
            viewController = MovieListViewController()
            viewController.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        default:
            return UIViewController()
        }
        
        return viewController
    }
}

class HomeViewController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: Setup
    private func setupViews() {
        let moviesViewController = UINavigationController(rootViewController: HomeTabs.movies.viewController)
        tabBar.tintColor = .primaryColor
        
        setViewControllers([moviesViewController], animated: true)
    }
}
