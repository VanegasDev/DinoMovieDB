//
//  MyFavoritesViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/9/21.
//

import UIKit
import Combine

class MyFavoritesViewController: UIViewController {
    enum FavoriteType: Int {
        case movies
        case shows
    }
    
    private let viewModel = ItemListViewModel()
    private let moviesService: MoviesServiceType = MoviesService()
    private let showsService: TVShowsServiceType = TVShowsService()
    private let pagination: PaginationManagerType = PaginationManager()
    
    private lazy var selectItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(askForSortType))
        button.tintColor = .systemBlue
        
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var sortedBy: SortType = .ascendant {
        didSet {
            changeItemType()
        }
    }
    private var itemType: FavoriteType = .movies {
        didSet {
            changeItemType()
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedController()
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: OBJC Methods
    @objc private func changeContentType(_ sender: UISegmentedControl) {
        guard let chosenType = FavoriteType(rawValue: sender.selectedSegmentIndex) else { return }
        
        itemType = chosenType
    }
    
    @objc private func askForSortType() {
        let actionSheet: UIAlertController
        let ascendantAction = UIAlertAction(title: R.string.localization.favorites_sort_by_asc(), style: .default) { [weak self] _ in
            self?.sortedBy = .ascendant
        }
        let descendantAction = UIAlertAction(title: R.string.localization.favorites_sort_by_desc(), style: .default) { [weak self] _ in
            self?.sortedBy = .descendat
        }
        
        actionSheet = .customActionSheet(title: R.string.localization.favorites_sort_title(), actions: [ascendantAction, descendantAction])
        
        present(actionSheet, animated: true)
    }
    
    // MARK: Setup
    private func setupSegmentedController() {
        let segmentedView: UISegmentedControl
        let segmentedControlTitles = [
            R.string.localization.favorites_movies_title(),
            R.string.localization.favorites_tv_shows_title()
        ]
        
        segmentedView = UISegmentedControl(items: segmentedControlTitles)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action: #selector(changeContentType), for: .valueChanged)
        
        navigationItem.titleView = segmentedView
    }
    
    private func setupViews() {
        title = R.string.localization.favorites_title()
        
        addHosting(ItemListView(viewModel: viewModel))
        navigationItem.rightBarButtonItem = selectItemButton
    }
    
    private func setupBindings() {
        let fetchItemsPublisher = viewModel.fetchItemsOutput.receive(on: DispatchQueue.main)
        let itemTapPublisher = viewModel.itemTapOutput.receive(on: DispatchQueue.main)
        
        fetchItemsPublisher.sink(onReceived: itemType == .movies ? fetchFavoriteMovies : fetchFavoriteTVShows).store(in: &cancellables)
        itemTapPublisher.sink(onReceived: itemType == .movies ? openMovieDetails : openShowDetails).store(in: &cancellables)
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
    
    private func openMovieDetails(using id: Int) {
        navigationController?.pushViewController(MovieDetailViewController(with: id), animated: true)
    }
    
    private func openShowDetails(using id: Int) {
        navigationController?.pushViewController(TVShowDetailViewController(with: id), animated: true)
    }
    
    private func fetchShows(on page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        showsService.fetchFavoriteShows(on: page, sortedBy: sortedBy)
    }
    
    private func fetchMovies(on page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        moviesService.fetchFavoriteMovies(on: page, sortedBy: sortedBy)
    }
}
