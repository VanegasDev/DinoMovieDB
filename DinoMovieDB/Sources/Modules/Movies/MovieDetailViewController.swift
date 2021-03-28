//
//  MovieDetailViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: ViewController Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    private func setupViews() {
        title = "Movie Title"
        addHosting(MovieDetailView())
    }
}
