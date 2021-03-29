//
//  MovieDetailViewModel.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/28/21.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var bannerViewModel: TMDBBannerViewModel = .placeholder
    @Published var directorName: String = "-"
    @Published var duration: String = "0"
    @Published var overview: String = "No Description"
    @Published var cast: [CastPerson] = []
}
