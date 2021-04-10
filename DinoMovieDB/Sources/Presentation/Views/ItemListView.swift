//
//  ItemListView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/9/21.
//

import SwiftUI

struct ItemListView: View {
    @ObservedObject private var viewModel: ItemListViewModel
    private let columns = [
        GridItem(.flexible(minimum: 16)),
        GridItem(.flexible(minimum: 16)),
    ]
    
    init(viewModel: ItemListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.itemsViewModel) { viewModel in
                    ItemDetail(viewModel: viewModel)
                }
            }
            .padding()
            .background(Color(R.color.backgroundColor.name))
        }
        .onAppear(perform: {})
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(viewModel: ItemListViewModel())
    }
}
