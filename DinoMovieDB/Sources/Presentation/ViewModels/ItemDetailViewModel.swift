//
//  ItemDetailViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import Foundation
import Combine

class ItemDetailViewModel: ObservableObject, Identifiable {
    // MARK: Published
    @Published var title: String
    @Published var releaseDate: String
    @Published var rate: String
    @Published var imageUrl: URL?
    
    init(title: String, releaseDate: String, rate: String, imageUrl: URL?) {
        self.title = title
        // Uses our custom formatter
        self.releaseDate = DateFormatter.tmdbDatePreviewFormat(from: releaseDate)
        self.rate = rate
        self.imageUrl = imageUrl
    }
}
