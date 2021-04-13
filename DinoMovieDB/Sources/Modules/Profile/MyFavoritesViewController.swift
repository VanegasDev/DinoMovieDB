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
        let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(askForContentType))
        button.tintColor = .systemBlue
        
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var itemType: FavoriteType = .movies {
        didSet {
            changeItemType()
        }
    }
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupViews()
        setupBindings()
    }
    
    // MARK: OBJC Methods
    @objc private func askForContentType() {
        let chooseMoviesAction = UIAlertAction(title: itemType == .movies ? "Movies ✓" : "Movies", style: .default) { [weak self] _ in
            self?.itemType = .movies
        }
        let chooseTVShowsAction = UIAlertAction(title: itemType == .shows ? "TVShows ✓" : "TVShows", style: .default) { [weak self] _ in
            self?.itemType = .shows
        }
        
        present(UIAlertController.customActionSheet(title: "Select Item Type:", actions: [chooseMoviesAction, chooseTVShowsAction]), animated: true)
    }
    
    // MARK: Setup
    private func setupViews() {
        title = R.string.localization.favorites_title()
        
        addHosting(ItemListView(viewModel: viewModel))
        navigationItem.rightBarButtonItem = selectItemButton
    }
    
    private func setupBindings() {
        let fetchItemsPublisher = viewModel.fetchItemsOutput.receive(on: DispatchQueue.main)
        
        fetchItemsPublisher.sink(onReceived: itemType == .movies ? fetchFavoriteMovies : fetchFavoriteTVShows).store(in: &cancellables)
    }
    
    // MARK: Functionality
    private func changeItemType() {
        viewModel.itemsViewModel = []
        
        pagination.resetPagination()
        itemType == .movies ? fetchFavoriteMovies() : fetchFavoriteTVShows()
    }
    
    private func fetchFavoriteMovies() {
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        pagination.paginate(request: { fetchMovies(on: nextPage) })
            .sink { [weak self] in
                self?.pagination.state = .readyForPagination
            } error: { [weak self] error in
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)

                self?.present(alert, animated: true)
            } onReceived: { [weak self] moviesResponse in
                self?.viewModel.itemsViewModel += moviesResponse.mapIntoItemPreviewViewModel(mediaType: .movies)
            }
            .store(in: &cancellables)
    }
    
    private func fetchFavoriteTVShows() {
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        pagination.paginate(request: { fetchShows(on: nextPage) })
            .sink { [weak self] in
                self?.pagination.state = .readyForPagination
            } error: { [weak self] error in
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)
                
                self?.present(alert, animated: true)
            } onReceived: { [weak self] tvShowsResponse in
                self?.viewModel.itemsViewModel += tvShowsResponse.mapIntoItemPreviewViewModel(mediaType: .tvShows)
            }
            .store(in: &cancellables)
    }
    
    private func fetchShows(on page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        showsService.fetchPopularShows(page: page)
    }
    
    private func fetchMovies(on page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        moviesService.fetchFavoriteMovies(on: page)
    }
}
