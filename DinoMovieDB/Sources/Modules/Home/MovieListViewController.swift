//
//  MovieListViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import SwiftUI
import Combine

class MovieListViewController: UIViewController {
    // Propiedades
    private let moviesService: MoviesServiceType = MoviesService()
    private let pagination: PaginationManagerType = PaginationManager()
    private let viewModel = MovieListViewModel()
    
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
        title = R.string.localization.movie_list_title()
        
        // TODO: Setup Bindings when working on actions
        addHosting(MovieListView(viewModel: viewModel))
    }
    
    private func setupBindings() {
        let fetchMoviesPublisher = viewModel.fetchUpcomingMoviesPublisher.receive(on: DispatchQueue.main)
        
        fetchMoviesPublisher.sink(receiveValue: fetchMovies).store(in: &cancellables)
    }
    
    // Funcionalidad
    private func fetchMovies() {
        // Verificar si se puede paginar
        guard let nextPage = pagination.nextPage, pagination.state == .readyForPagination else { return }
        
        // Descargar proximas peliculas
        pagination.paginate(request: moviesService.fetchUpcomingMovies(page: nextPage).eraseToAnyPublisher)
            .sink { [weak self] in
                // Le notifica que se puede paginar
                self?.pagination.state = .readyForPagination
            } error: { [weak self] error in
                // Presentar Alerta de Error
                let alert = UIAlertController.errorAlert(description: error.localizedDescription)
                self?.present(alert, animated: true)
            } onReceived: { [weak self] receivedMovies in
                // Actualizar peliculas
                self?.updateReceivedMovies(receivedMovies)
            }
            .store(in: &cancellables)
    }
    
    // Funciones para hacer mas legible el codigo
    private func updateReceivedMovies(_ movies: [MoviePreview] = []) {
        let movies = movies.compactMap(convertToDetailViewModel)
        viewModel.moviesViewModel += movies
    }
    
    private func convertToDetailViewModel(_ movie: MoviePreview) -> ItemDetailViewModel {
        let title = movie.title
        let release = movie.releaseDate
        let rate = "\(movie.voteAverage)"
        let imageUrl = URL(string: "\(TMDBConfiguration.imageBasePath)\(movie.imagePath ?? "")")
        
        return ItemDetailViewModel(title: title, releaseDate: release, rate: rate, imageUrl: imageUrl)
    }
}
