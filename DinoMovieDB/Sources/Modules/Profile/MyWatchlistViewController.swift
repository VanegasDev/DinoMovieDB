//
//  MyWatchlistViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/17/21.
//

import UIKit
import Combine

class MyWatchlistViewController: AccountItemsViewController {
    // MARK: Properties
    private let viewModel = ItemListViewModel()
    
    // MARK: VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
        
        onChangeItemType = changeItemType
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Setup
    private func setupViews() {
        title = R.string.localization.watchlist_title()
        
        addHosting(ItemListView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        let fetchItemsPublisher = viewModel.fetchItemsOutput.receive(on: DispatchQueue.main)
        let itemTapPublisher = viewModel.itemTapOutput.receive(on: DispatchQueue.main)
        
        fetchItemsPublisher.sink(onReceived: itemType == .movies ? fetchWatchlistMovies : fetchWatchlistTVShows).store(in: &cancellables)
        itemTapPublisher.sink(onReceived: itemType == .movies ? openMovieDetails : openShowDetails).store(in: &cancellables)
    }
    
    // MARK: Functionality
    private func changeItemType() {
        viewModel.itemsViewModel = []
        
        pagination.resetPagination()
        itemType == .movies ? fetchWatchlistMovies() : fetchWatchlistTVShows()
    }
    
    private func fetchWatchlistMovies() {
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        pagination.paginate(request: { fetchMovies(on: nextPage) })
            .sink { [weak self] in
                self?.pagination.state = .readyForPagination
            } error: { [weak self] error in
                self?.presentError(error)
            } onReceived: { [weak self] moviesResponse in
                self?.viewModel.itemsViewModel += moviesResponse.mapIntoItemPreviewViewModel(mediaType: .movies)
            }
            .store(in: &cancellables)
    }
    
    private func fetchWatchlistTVShows() {
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        pagination.paginate(request: { fetchShows(on: nextPage) })
            .sink { [weak self] in
                self?.pagination.state = .readyForPagination
            } error: { [weak self] error in
                self?.presentError(error)
            } onReceived: { [weak self] tvShowsResponse in
                self?.viewModel.itemsViewModel += tvShowsResponse.mapIntoItemPreviewViewModel(mediaType: .tvShows)
            }
            .store(in: &cancellables)
    }
    
    private func fetchShows(on page: Int) -> AnyPublisher<APIResponse<[TVShowPreview]>, Error> {
        showsService.fetchWatchlistShows(on: page, sortedBy: sortedBy)
    }
    
    private func fetchMovies(on page: Int) -> AnyPublisher<APIResponse<[MoviePreview]>, Error> {
        moviesService.fetchWatchlistMovies(on: page, sortedBy: sortedBy)
    }
}

