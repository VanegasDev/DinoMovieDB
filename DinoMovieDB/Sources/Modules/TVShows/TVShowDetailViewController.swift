//
//  TVShowDetailViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/3/21.
//

import UIKit
import Combine

class TVShowDetailViewController: UIViewController {
    private let showId: Int
    private let viewModel = TVShowDetailViewModel()
    private let itemDetailService: ItemDetailServiceType = ItemDetailService()
    private let itemStateService: ItemsServiceType = ItemsService()
    
    private lazy var rateItButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.string.localization.movie_detail_rate_button_title(), style: .plain, target: self, action: #selector(rateShow))
        button.tintColor = .systemBlue
        button.isEnabled = false
        
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var showDetail: ShowDetail?
    private var showState: ItemState?
    
    init(with showId: Int) {
        self.showId = showId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }
    
    // MARK: ViewController Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    // MARK: OBJC Functions
    @objc private func rateShow() {
        let viewController = ShowRateViewController(showId: showId, showTitle: showDetail?.title ?? "No Title")
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    // MARK: Setup
    private func setupViews() {
        title = "No Title"
        
        navigationItem.rightBarButtonItem = rateItButton
        addHosting(TVShowDetailView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        let fetchDetailPublisher = viewModel.fetchDetailOutput.receive(on: DispatchQueue.main)
        
        fetchDetailPublisher.sink(receiveValue: fetchShowDetails).store(in: &cancellables)
    }
    
    // MARK: Functionality
    private func fetchShowDetails() {
        // Fetches details of a tvshow
        itemDetailService.fetchDetailOfTVShow(id: showId, appendToRequest: TMDBConfiguration.creditsAppendParameter)
            .flatMap { [weak self] detailResponse -> AnyPublisher<ItemState, Error> in
                guard let self = self else { return Fail(error: TMDBError.selfNotFound).eraseToAnyPublisher() }
                
                self.showDetail = detailResponse
                
                // Fetches tvshow state
                return self.itemStateService.fetchTvShowsState(showId: detailResponse.id)
            }
            .sink { [weak self] in
                // Receives API Response
                self?.viewModel.isLoading = false
            } error: { [weak self] error in
                // Presents error alert
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)
                self?.present(alert, animated: true)
            } onReceived: { [weak self] stateResponse in
                // Receives tvshow state response
                self?.showState = stateResponse
                self?.updateShowDetail()
            }
            .store(in: &cancellables)
    }
    
    // Update Movie Detail with received data
    private func updateShowDetail() {
        let posterUrlString = "\(TMDBConfiguration.imageBasePath)\(showDetail?.posterPath ?? "")"
        let showBannerViewModel = TMDBBannerViewModel(url: URL(string: posterUrlString),
                                                      title: showDetail?.title ?? "No Description",
                                                      releaseDate: showDetail?.firstAirDate ?? "",
                                                      genderName: showDetail?.genres.first?.name ?? "Unknown",
                                                      voteAverage: "\(showDetail?.voteAverage ?? 0)",
                                                      onWatchlist: addToWatchlist,
                                                      onFavorites: markAsFavorite)
        showBannerViewModel.isOnWatchlist = showState?.isOnWatchlist ?? false
        showBannerViewModel.isOnFavorites = showState?.isFavorite ?? false
        
        title = showDetail?.title ?? "No Title"
        viewModel.bannerViewModel = showBannerViewModel
        viewModel.creator = showDetail?.creators.first?.name ?? "Unknown"
        viewModel.duration = TMDBTimeFormatter.default.formatMinutesToHourMinutes(from: showDetail?.runtime.first ?? 0)
        viewModel.overview = showDetail?.overview ?? "No Description"
        viewModel.cast = showDetail?.credits?.cast ?? []
        viewModel.seasons = showDetail?.seasons ?? []
        rateItButton.isEnabled = true
    }
    
    private func addToWatchlist(_ isOnWatchlist: Bool) {
        let parameters = WatchlistsState(mediaType: MediaType.tvShows.rawValue, itemId: showId, isOnWatchList: !isOnWatchlist)
        
        itemStateService.addToWatchList(itemParams: parameters)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewModel.bannerViewModel.isWatchlistButtonEnabled = false })
            .sink { [weak self] in
                self?.viewModel.bannerViewModel.isWatchlistButtonEnabled = true
            } onReceived: { [weak self] _ in
                self?.viewModel.bannerViewModel.isOnWatchlist.toggle()
            }
            .store(in: &cancellables)
    }
    
    private func markAsFavorite(_ isFavorite: Bool) {
        let parameters = FavoritesState(mediaType: MediaType.tvShows.rawValue, itemId: showId, isFavorite: !isFavorite)
        
        itemStateService.markAsFavorite(itemParams: parameters)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewModel.bannerViewModel.isFavoriteButtonEnabled = false })
            .sink { [weak self] in
                self?.viewModel.bannerViewModel.isFavoriteButtonEnabled = true
            } onReceived: { [weak self] _ in
                self?.viewModel.bannerViewModel.isOnFavorites.toggle()
            }
            .store(in: &cancellables)
    }
}
