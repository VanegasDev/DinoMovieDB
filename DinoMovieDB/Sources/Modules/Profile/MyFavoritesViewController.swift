//
//  MyFavoritesViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/9/21.
//

import UIKit
import Combine

class MyFavoritesViewController: UIViewController {
    enum FavoriteType {
        case movies
        case shows
    }
    
    private let viewModel = ItemListViewModel()
    private let moviesService: MoviesServiceType = MoviesService()
    private let showsService: TVShowsServiceType = TVShowsService()
    private let pagination: PaginationManagerType = PaginationManager()
    
    private lazy var selectItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: nil)
        button.tintColor = .systemBlue
        
        return button
    }()
    
    private var itemType: FavoriteType = .movies
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupViews()
    }
    
    // MARK: Setup
    private func setupViews() {
        title = R.string.localization.favorites_title()
        
        addHosting(ItemListView(viewModel: viewModel))
        navigationItem.rightBarButtonItem = selectItemButton
    }
}
