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
    private let viewModel = ItemListViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    private var searchState: SearchState = .readyForSearch
    
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
        
        addHosting(ItemListView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        let fetchMoviesPublisher = viewModel.fetchItemsOutput.receive(on: DispatchQueue.main)
        let openShowPublisher = viewModel.itemTapOutput.receive(on: DispatchQueue.main)
        
        fetchMoviesPublisher.sink(receiveValue: fetchShows).store(in: &cancellables)
        openShowPublisher.sink(onReceived: openShowDetails).store(in: &cancellables)
    }
    
    // MARK: Functionality
    private func fetchShows() {
        // Verifies pagination availability
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        // Fetches popular tv shows
        pagination.paginate(request: { requestTVShows(on: nextPage) })
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
    
    private func openShowDetails(using id: Int) {
        navigationController?.pushViewController(TVShowDetailViewController(with: id), animated: true)
    }
    
    private func requestTVShows(on page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        if searchState == .readyForSearch {
            return tvShowsService.fetchPopularShows(page: page)
        }
        
        return tvShowsService.search(show: navigationItem.searchController?.searchBar.text ?? "", on: page)
    }
    
    private func updateReceivedTVShows(_ shows: [TVShowPreview] = []) {
        let shows = shows.compactMap(convertToDetailViewModel)
        viewModel.itemsViewModel += shows
    }
    
    private func convertToDetailViewModel(_ show: TVShowPreview) -> ItemDetailViewModel {
        let title = show.title
        let release = show.releaseDate
        let rate = "\(show.voteAverage ?? 0)"
        let imageUrl = URL(string: "\(TMDBConfiguration.imageBasePath)\(show.imagePath ?? "")")
        
        return ItemDetailViewModel(itemType: .tvShows, itemId: show.id, title: title ?? "Empty", releaseDate: release ?? "Empty", rate: rate, imageUrl: imageUrl)
    }
}

extension TVShowsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchState = searchText.isEmpty ? .readyForSearch : .searching
        viewModel.itemsViewModel = []
        
        pagination.resetPagination()
        fetchShows()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchState = .readyForSearch
        viewModel.itemsViewModel = []
        
        pagination.resetPagination()
        fetchShows()
    }
}
