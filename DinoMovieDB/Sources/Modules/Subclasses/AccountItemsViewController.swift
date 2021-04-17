//
//  AccountItemsViewController.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/17/21.
//

import UIKit
import Combine

class AccountItemsViewController: UIViewController {
    // MARK: Properties
    private lazy var sortItemsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(askForSortType))
        button.tintColor = .systemBlue
        
        return button
    }()
    
    let moviesService: MoviesServiceType = MoviesService()
    let showsService: TVShowsServiceType = TVShowsService()
    let pagination: PaginationManagerType = PaginationManager()
    
    var onChangeItemType: (() -> Void)?
    var cancellables = Set<AnyCancellable>()
    var sortedBy: SortType = .ascendant {
        didSet {
            onChangeItemType?()
        }
    }
    
    var itemType: MediaType = .movies {
        didSet {
            onChangeItemType?()
        }
    }
    
    // MARK: VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedController()
    }
    
    // MARK: OBJC Methods
    @objc private func changeContentType(_ sender: UISegmentedControl) {
        guard let chosenType = MediaType(rawValue: sender.selectedSegmentIndex) else { return }
        
        itemType = chosenType
    }
    
    @objc private func askForSortType() {
        let actionSheet: UIAlertController
        let ascendantAction = UIAlertAction(title: R.string.localization.favorites_sort_by_asc(), style: .default) { [weak self] _ in
            self?.sortedBy = .ascendant
        }
        let descendantAction = UIAlertAction(title: R.string.localization.favorites_sort_by_desc(), style: .default) { [weak self] _ in
            self?.sortedBy = .descendat
        }
        
        actionSheet = .customActionSheet(title: R.string.localization.favorites_sort_title(), actions: [ascendantAction, descendantAction])
        
        present(actionSheet, animated: true)
    }
    
    // MARK: Setup
    private func setupViews() {
        navigationItem.rightBarButtonItem = sortItemsButton
    }
    
    private func setupSegmentedController() {
        let segmentedView: UISegmentedControl
        let segmentedControlTitles = [
            R.string.localization.favorites_movies_title(),
            R.string.localization.favorites_tv_shows_title()
        ]
        
        segmentedView = UISegmentedControl(items: segmentedControlTitles)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action: #selector(changeContentType), for: .valueChanged)
        
        navigationItem.titleView = segmentedView
    }
    
    // MARK: Functionality
    func presentError(_ error: Error) {
        let alert = UIAlertController.errorAlert(description: error.localizedDescription)
        
        present(alert, animated: true)
    }
    
    func openMovieDetails(using id: Int) {
        navigationController?.pushViewController(MovieDetailViewController(with: id), animated: true)
    }
    
    func openShowDetails(using id: Int) {
        navigationController?.pushViewController(TVShowDetailViewController(with: id), animated: true)
    }
}
