//
//  MovieListView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/7/21.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject private var viewModel: MovieListViewModel
    private let columns = [
        GridItem(.flexible(minimum: 16)),
        GridItem(.flexible(minimum: 16)),
    ]
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.moviesViewModel) { movie in
                    ItemDetail(viewModel: movie)
                        .frame(height: 250)
                        .onAppear {
                            let movieIndex = viewModel.moviesViewModel.firstIndex { $0.id == movie.id } ?? 0
                            let distance = viewModel.moviesViewModel.distance(from: movieIndex, to: viewModel.moviesViewModel.count)
                            
                            if distance < 4 {
                                viewModel.fetchUpcomingMoviesTrigger.send()
                            }
                        }
                }
            }
            .padding()
            .background(Color(R.color.backgroundColor.name))
        }
        .onAppear(perform: viewModel.fetchUpcomingMoviesTrigger.send)
    }

}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieListViewModel())
    }
}
