//
//  MovieRateViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

import UIKit
import Combine

class MovieRateViewController: UIViewController {
    private let itemsStateService: ItemsServiceType = ItemsService()
    private let viewModel: RateItemViewModel
    private let movieId: Int
    private let movieName: String
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.string.localization.done_alert_title(), style: .plain, target: self, action: #selector(finishRate))
        button.tintColor = .systemBlue
        
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int, movieName: String) {
        self.movieId = movieId
        self.movieName = movieName
        viewModel = RateItemViewModel(itemId: movieId, itemName: movieName)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) hasn't been implemented")
    }
    
    // MARK: ViewController Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    // MARK: OBJC Function
    @objc private func finishRate() {
        dismiss(animated: true)
    }
    
    // MARK: Setup
    private func setupViews() {
        title = R.string.localization.movie_rate_title()
        navigationItem.rightBarButtonItem = doneButton
        
        addHosting(RateItemView(with: viewModel))
    }
    
    private func setupBindings() {
        let ratePublisher = viewModel.rateOutputPublisher.receive(on: DispatchQueue.main)
        let deletePublisher = viewModel.deleteRateOutputPublisher.receive(on: DispatchQueue.main)
        let onAppearPublisher = viewModel.onAppearOutputPublisher.receive(on: DispatchQueue.main)
        
        ratePublisher.sink(onReceived: rateMovie).store(in: &cancellables)
        deletePublisher.sink(onReceived: deleteRating).store(in: &cancellables)
        onAppearPublisher.sink(onReceived: fetchState).store(in: &cancellables)
    }
    
    // MARK: Functionality
    private func rateMovie() {
        itemsStateService.rate(movieId: movieId, rating: viewModel.ratingValue)
            .map { _ in }
            .sink(response: responseIsReceived, error: showErrorAlert, onReceived: { [weak self] in self?.viewModel.isItemRated = true })
            .store(in: &cancellables)
    }
    
    private func deleteRating() {
        itemsStateService.deleteRateOn(movieId: movieId)
            .map { _ in }
            .sink(response: responseIsReceived, error: showErrorAlert, onReceived: { [weak self] in self?.viewModel.isItemRated = false })
            .store(in: &cancellables)
    }
    
    private func fetchState() {
        itemsStateService.fetchMoviesState(movieId: movieId)
            .map(\.rating)
            .sink(response: responseIsReceived, error: showErrorAlert, onReceived: updateViewModel)
            .store(in: &cancellables)
    }
    
    private func updateViewModel(with rating: Rate?) {
        viewModel.isItemRated = rating != nil
        viewModel.ratingValue = Int(rating?.value ?? 0) / 2
    }
    
    private func responseIsReceived() {
        viewModel.isLoading = false
    }
    
    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController.errorAlert(description: error.localizedDescription, completion: { [weak self] _ in self?.finishRate() })
        present(alert, animated: true)
    }
}
