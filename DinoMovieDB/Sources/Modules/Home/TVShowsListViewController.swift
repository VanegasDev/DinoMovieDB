//
//  TVShowsListViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import UIKit
import Combine

class TVShowsListViewController: TMDBSearchViewController {
    // MARK: Properties
    private let tvShowsService: TVShowsServiceType = TVShowsService()
    private let viewModel = ItemListViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupViews()
        setupBindings()
        fetchInformation = fetchShows
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Override
    override func resetList() {
        super.resetList()
        
        viewModel.itemsViewModel = []
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
