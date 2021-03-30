//
//  MovieRateViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

import UIKit

class MovieRateViewController: UIViewController {
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.string.localization.done_alert_title(), style: .plain, target: self, action: #selector(finishRate))
        button.tintColor = .systemBlue
        
        return button
    }()
    
    // MARK: ViewController Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: Setup
    private func setupViews() {
        title = R.string.localization.movie_rate_title()
        navigationItem.rightBarButtonItem = doneButton
        
        addHosting(RateMovieView())
    }
    
    // MARK: OBJC Function
    @objc private func finishRate() {
        dismiss(animated: true)
    }
}
