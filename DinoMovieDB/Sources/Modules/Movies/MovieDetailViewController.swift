//
//  MovieDetailViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private let movieTitle: String
    private lazy var rateItButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.string.localization.movie_detail_rate_button_title(), style: .plain, target: self, action: #selector(rateMovie))
        button.tintColor = .systemBlue
        
        return button
    }()
    
    init(movie title: String) {
        movieTitle = title
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder)")
    }
    
    // MARK: ViewController Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func rateMovie() {
        
    }
    
    private func setupViews() {
        title = movieTitle
        
        addHosting(MovieDetailView(viewModel: MovieDetailViewModel()))
        navigationItem.rightBarButtonItem = rateItButton
    }
}
