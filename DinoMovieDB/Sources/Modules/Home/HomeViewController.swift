//
//  HomeViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import UIKit

enum HomeTabs: Int {
    case movies
    case tvShows
    case profile
}

class HomeViewController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }
}
