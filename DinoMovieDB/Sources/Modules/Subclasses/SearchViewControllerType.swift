//
//  SearchViewControllerType.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/12/21.
//

import UIKit

class TMDBSearchViewController: UIViewController {
    let pagination: PaginationManagerType = PaginationManager()
    
    var searchState: SearchState = .readyForSearch
    var fetchInformation: (() -> Void)?
    
    func resetList() {
        pagination.resetPagination()
    }
}

extension TMDBSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchState = searchText.isEmpty ? .readyForSearch : .searching
        
        resetList()
        fetchInformation?()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchState = .readyForSearch
        
        resetList()
        fetchInformation?()
    }
}
