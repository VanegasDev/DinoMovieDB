//
//  ItemDetailViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import Foundation
import Combine

class ItemDetailViewModel: ObservableObject, Identifiable {
    @Published var title: String
    @Published var releaseDate: String
    @Published var rate: String
    @Published var imageUrl: URL?
    
    init(title: String, releaseDate: String, rate: String, imageUrl: URL?) {
        self.title = title
        self.releaseDate = releaseDate
        self.rate = rate
        self.imageUrl = imageUrl
    }
}
