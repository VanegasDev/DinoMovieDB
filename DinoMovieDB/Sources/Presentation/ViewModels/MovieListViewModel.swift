//
//  MovieListViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/7/21.
//

import SwiftUI
import Combine

class MovieListViewModel: ObservableObject {
    @Published var moviesViewModel: [ItemDetailViewModel] = []
    
    init() {
        moviesViewModel = (0 ... 100).map { _ in ItemDetailViewModel() }
    }
}
