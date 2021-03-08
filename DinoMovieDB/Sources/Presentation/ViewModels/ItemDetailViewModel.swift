//
//  ItemDetailViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import Foundation
import Combine

class ItemDetailViewModel: ObservableObject, Identifiable {
    @Published var title: String = "-"
    @Published var releaseDate: String = "-"
    @Published var rate: String = "0"
    @Published var imageUrl: URL?
}
