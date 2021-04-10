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
                ForEach(viewModel.itemsViewModel) { itemViewModel in
                    ItemDetail(viewModel: itemViewModel)
                        .frame(height: 250)
                        .onAppear {
                            if viewModel.itemsViewModel.shouldPaginate(on: itemViewModel) {
                                viewModel.fetchItemsInput.send()
                            }
                        }
                        .onTapGesture { self.viewModel.itemTapInput.send(itemViewModel.itemId) }
                }
            }
            .padding()
            .background(Color(R.color.backgroundColor.name))
        }
        .onAppear(perform: viewModel.fetchItemsInput.send)
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(viewModel: ItemListViewModel())
    }
}
