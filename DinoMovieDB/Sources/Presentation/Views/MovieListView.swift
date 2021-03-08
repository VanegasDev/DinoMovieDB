//
//  MovieListView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/7/21.
//

import SwiftUI

struct MovieListView: View {
    let data = (1...100).map { _ in ItemDetailViewModel() }

    let columns = [
        GridItem(.flexible(minimum: 16)),
        GridItem(.flexible(minimum: 16)),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(data) { viewModel in
                    ItemDetail(viewModel: viewModel)
                }
            }
            .padding(.horizontal)
        }
    }

}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
