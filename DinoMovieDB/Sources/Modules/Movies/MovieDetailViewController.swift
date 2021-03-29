//
//  MovieDetailViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private lazy var rateItButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Rate it!", style: .plain, target: self, action: #selector(rateMovie))
        button.tintColor = .systemBlue
        
        return button
    }()
    
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
        title = "Movie Title"
        
        addHosting(MovieDetailView(viewModel: MovieDetailViewModel()))
        navigationItem.rightBarButtonItem = rateItButton
    }
}
