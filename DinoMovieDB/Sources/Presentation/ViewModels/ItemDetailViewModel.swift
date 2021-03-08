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
    @Published var imageUrl: URL? = URL(string: "https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_683/https://www.pixinfocus.com/wp-content/uploads/2020/03/Portrait-vs-Landscape-2-683x1024.jpg")
}
