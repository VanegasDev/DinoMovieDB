//
//  MovieDetailViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    private let movieId: Int
    private let itemsDetailService: ItemDetailServiceType = ItemDetailService()
    private let itemsStateService: ItemsServiceType = ItemsService()
    private let viewModel = MovieDetailViewModel()
    
    private lazy var rateItButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.string.localization.movie_detail_rate_button_title(), style: .plain, target: self, action: #selector(rateMovie))
        button.tintColor = .systemBlue
        
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var movieDetail: MovieDetail?
    private var movieState: ItemState?
    
    init(with movieId: Int) {
        self.movieId = movieId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder)")
    }
    
    // MARK: ViewController Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: OBJC Actions
    @objc private func rateMovie() {
        let viewController = UINavigationController(rootViewController: MovieRateViewController())
        present(viewController, animated: true)
    }
    
    // MARK: Setup
    private func setupViews() {
        title = "No Title"
        
        addHosting(MovieDetailView(viewModel: viewModel))
        navigationItem.rightBarButtonItem = rateItButton
    }
    
    private func setupBindings() {
        let fetchDetailPublisher = viewModel.fetchDetailsTriggerPublisher.receive(on: DispatchQueue.main)
        
        fetchDetailPublisher.sink(onReceived: fetchMovieDetails).store(in: &cancellables)
    }
    
    // MARK: Functionality
    private func fetchMovieDetails() {
        // Fetches detail of a movie
        itemsDetailService.fetchDetailOfMovie(id: movieId, appendToRequest: TMDBConfiguration.creditsAppendParameter)
            .flatMap { [weak self] detailResponse -> AnyPublisher<ItemState, Error> in
                guard let self = self else { return Fail(error: TMDBError.selfNotFound).eraseToAnyPublisher() }
                
                self.movieDetail = detailResponse
                
                // Fetches movie state
                return self.itemsStateService.fetchMoviesState(movieId: detailResponse.id)
            }
            .sink { [weak self] in
                // Receive API Response
                self?.viewModel.isLoading = false
            } error: { [weak self] error in
                // Presents error alert
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)
                self?.present(alert, animated: true)
            } onReceived: { [weak self] stateResponse in
                // Receives Movie State Response
                self?.movieState = stateResponse
                self?.updateMovieDetail()
            }
            .store(in: &cancellables)
    }
    
    // Update Movie Detail with received data
    private func updateMovieDetail() {
        let posterUrlString = "\(TMDBConfiguration.imageBasePath)\(movieDetail?.posterPath ?? "")"
        let movieBannerViewModel = TMDBBannerViewModel(url: URL(string: posterUrlString),
                                                       title: movieDetail?.title ?? "No Description",
                                                       releaseDate: movieDetail?.releaseDate ?? "",
                                                       genderName: movieDetail?.genres.first?.name ?? "Unknown",
                                                       voteAverage: "\(movieDetail?.voteAverage ?? 0)",
                                                       onWatchlist: addToWatchlist,
                                                       onFavorites: markAsFavorite)
        movieBannerViewModel.isOnWatchlist = movieState?.isOnWatchlist ?? false
        movieBannerViewModel.isOnFavorites = movieState?.isFavorite ?? false
        
        title = movieDetail?.title ?? "No Title"
        viewModel.bannerViewModel = movieBannerViewModel
        viewModel.directorName = movieDetail?.credits?.crew.first { $0.job == TMDBConfiguration.directorJobDescription }?.name ?? "Unknown"
        viewModel.duration = TMDBTimeFormatter.default.formatMinutesToHourMinutes(from: movieDetail?.runtime ?? 0)
        viewModel.overview = movieDetail?.overview ?? "No Description"
        viewModel.cast = movieDetail?.credits?.cast ?? []
    }
    
    private func addToWatchlist(_ isOnWatchlist: Bool) {
        let parameters = WatchlistsState(mediaType: MediaType.movies.rawValue, itemId: movieId, isOnWatchList: !isOnWatchlist)
        
        itemsStateService.addToWatchList(itemParams: parameters)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewModel.bannerViewModel.isWatchlistButtonEnabled = false })
            .sink { [weak self] in
                self?.viewModel.bannerViewModel.isWatchlistButtonEnabled = true
            } onReceived: { [weak self] _ in
                self?.viewModel.bannerViewModel.isOnWatchlist.toggle()
            }
            .store(in: &cancellables)
    }
    
    private func markAsFavorite(_ isFavorite: Bool) {
        let parameters = FavoritesState(mediaType: MediaType.movies.rawValue, itemId: movieId, isFavorite: !isFavorite)
        
        itemsStateService.markAsFavorite(itemParams: parameters)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewModel.bannerViewModel.isFavoriteButtonEnabled = false })
            .sink { [weak self] in
                self?.viewModel.bannerViewModel.isFavoriteButtonEnabled = true
            } onReceived: { [weak self] _ in
                self?.viewModel.bannerViewModel.isOnFavorites.toggle()
            }
            .store(in: &cancellables)
    }
}
