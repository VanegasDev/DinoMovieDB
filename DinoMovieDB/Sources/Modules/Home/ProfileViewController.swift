//
//  ProfileViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/19/21.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: Lifecycle
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
        title = R.string.localization.profile_title()
        
        addHosting(ProfileView())
    }
}
