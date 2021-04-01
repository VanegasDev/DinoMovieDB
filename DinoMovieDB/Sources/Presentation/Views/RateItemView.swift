//
//  RateItemView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

import SwiftUI

struct RateItemView: View {
    @ObservedObject private var viewModel: RateItemViewModel
    
    init(with viewModel: RateItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 37) {
            VStack(spacing: 16) {
                Text(R.string.localization.item_rate_description(viewModel.itemName))
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                TMDBStarRateView(numberOfChosenStars: $viewModel.ratingValue)
                    .foregroundColor(Color(R.color.tertiaryFixed.name))
            }
            
            if viewModel.isItemRated {
                TMDBDoneAlertView()
            }
            
            Spacer()
        }
        .padding(16)
        .tmdbActivityIndicator(isAnimating: viewModel.isLoading)
        .background(Color(R.color.backgroundColor.name))
        .onAppear(perform: viewModel.onAppearInputPublisher.send)
    }
}

struct RateMovieView_Previews: PreviewProvider {
    static var previews: some View {
        RateItemView(with: RateItemViewModel(itemId: 1, itemName: "Godzilla"))
    }
}
