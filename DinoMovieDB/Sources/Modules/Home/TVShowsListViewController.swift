//
//  TVShowsListViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import UIKit
import Combine

class TVShowsListViewController: UIViewController {
    // Propiedades
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
        
        // TODO: Setup Bindings when working on actions
        addHosting(TVShowsListView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        let fetchMoviesPublisher = viewModel.fetchPopularShowsPublisher.receive(on: DispatchQueue.main)
        
        fetchMoviesPublisher.sink(receiveValue: fetchShows).store(in: &cancellables)
    }
    
    // Funcionalidad
    private func fetchShows() {
        // Verificar si se puede paginar
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        // Descargar tv shows populares
        pagination.paginate(request: tvShowsService.fetchPopularShows(page: nextPage).eraseToAnyPublisher)
            .sink { [weak self] in
                // Le notifica que se puede paginar
                self?.pagination.state = .readyForPagination
            } error: { [weak self] error in
                // Presentar Alerta de Error
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)
                self?.present(alert, animated: true)
            } onReceived: { [weak self] receivedMovies in
                // Actualizar tvshows
                self?.updateReceivedTVShows(receivedMovies)
            }
            .store(in: &cancellables)
    }
    
    // Funciones para hacer mas legible el codigo
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
