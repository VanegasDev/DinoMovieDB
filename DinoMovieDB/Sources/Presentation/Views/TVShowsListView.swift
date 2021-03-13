//
//  TVShowsListView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import SwiftUI

struct TVShowsListView: View {
    @ObservedObject private var viewModel: TVShowsListViewModel
    private let columns = [
        GridItem(.flexible(minimum: 16)),
        GridItem(.flexible(minimum: 16)),
    ]
    
    init(viewModel: TVShowsListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.showsViewModel) { show in
                    ItemDetail(viewModel: show)
                        .frame(height: 250)
                        .onAppear {
                            if viewModel.showsViewModel.shouldPaginate(on: show) {
                                viewModel.fetchPopularShowsTrigger.send()
                            }
                        }
                }
            }
            .padding()
            .background(Color(R.color.backgroundColor.name))
        }
        .onAppear(perform: viewModel.fetchPopularShowsTrigger.send)
    }
}

struct TVShowsListView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowsListView(viewModel: TVShowsListViewModel())
    }
}
