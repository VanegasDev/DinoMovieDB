//
//  MovieListViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import SwiftUI
import Combine

class MovieListViewController: UIViewController {
    private let viewModel = MovieListViewModel()
    
    // TODO: Setup Bindings when working on actions
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Setup
    private func setupViews() {
        title = "Movies"
        
        // TODO: Setup Bindings when working on actions
        addHosting(MovieListView(viewModel: viewModel))
    }
}
