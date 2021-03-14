//
//  TVShowsListViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import UIKit
import Combine

class TVShowsListViewController: UIViewController {
    // MARK: Properties
    private let tvShowsService: TVShowsServiceType = TVShowsService()
    private let pagination: PaginationManagerType = PaginationManager()
    private let viewModel = TVShowsListViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Setup
    private func setupViews() {
        title = R.string.localization.tv_shows_list_title()
        navigationItem.searchController?.searchBar.delegate = self
        
        addHosting(TVShowsListView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        let fetchMoviesPublisher = viewModel.fetchPopularShowsPublisher.receive(on: DispatchQueue.main)
        fetchMoviesPublisher.sink(receiveValue: fetchShows).store(in: &cancellables)
    }
    
    // MARK: Functionality
    private func fetchShows() {
        // Verifies pagination availability
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        // Fetches popular tv shows
        pagination.paginate(request: tvShowsService.fetchPopularShows(page: nextPage).eraseToAnyPublisher)
            .sink { [weak self] in
                // Notifies that is ready for fetching the next page
                self?.pagination.state = .readyForPagination
            } error: { [weak self] error in
                // Presents Error Alert
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)
                self?.present(alert, animated: true)
            } onReceived: { [weak self] receivedMovies in
                // Updates tv shows
                self?.updateReceivedTVShows(receivedMovies)
            }
            .store(in: &cancellables)
    }
    
    private func updateReceivedTVShows(_ shows: [TVShowPreview] = []) {
        let shows = shows.compactMap(convertToDetailViewModel)
        viewModel.showsViewModel += shows
    }
    
    private func convertToDetailViewModel(_ movie: TVShowPreview) -> ItemDetailViewModel {
        let title = movie.name
        let release = movie.releaseDate
        let rate = "\(movie.voteAverage)"
        let imageUrl = URL(string: "\(TMDBConfiguration.imageBasePath)\(movie.imagePath ?? "")")
        
        return ItemDetailViewModel(title: title, releaseDate: release, rate: rate, imageUrl: imageUrl)
    }
}

extension TVShowsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("SEARCH: \(searchText)")
    }
}
