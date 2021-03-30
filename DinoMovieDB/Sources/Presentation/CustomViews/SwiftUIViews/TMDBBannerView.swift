//
//  TMDBBannerView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import SwiftUI
import Kingfisher

struct TMDBBannerView: View {
    @ObservedObject private var viewModel: TMDBBannerViewModel
    
    init(viewModel: TMDBBannerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            KFImage(viewModel.url)
                .resizable()
            Color(R.color.tmdbBlack.name)
                .opacity(0.25)
            VStack(spacing: 0) {
                itemRate
                Spacer()
                itemDetails
            }
            .padding(8)
        }
        .aspectRatio(343/243, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color(R.color.tmdbShadow.name), radius: 10, x: 0, y: 5)
    }
    
    private var itemRate: some View {
        HStack(alignment: .top) {
            Text(viewModel.generName)
                .foregroundColor(Color(R.color.secondaryColor.name))
                .font(.system(size: 13))
                .padding(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 5).stroke(Color(R.color.secondaryColor.name))
                )
            Spacer()
            Text(viewModel.voteAverage)
                .tmdbItemRate(size: 50, fontSize: 18, fontWeight: .semibold)
        }
    }
    
    private var itemDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.releaseDate)
                .font(.system(size: 13))
            HStack(spacing: 8) {
                Text(viewModel.title)
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                Spacer()
                Button(action: viewModel.onWatchlistTap) {
                    Image(systemName: viewModel.isOnWatchlist ? "eye.slash" : "eye")
                }
                .frame(height: 24)
                Button(action: viewModel.onFavoritesTap) {
                    Image(systemName: viewModel.isOnFavorites ? "heart.slash" : "heart")
                }
                .frame(height: 24)
            }
        }
        .foregroundColor(.white)
    }
}

struct TMDBBannerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TMDBBannerViewModel(url: URL(string: "https://elainescottphotographydotcom.files.wordpress.com/2016/01/yukon-mountain-scene.png"),
                                            title: "Godzilaa",
                                            releaseDate: "June 23, 2021",
                                            genderName: "Terror",
                                            voteAverage: "15",
                                            isOnWatchlist: true,
                                            isOnFavorites: true,
                                            onWatchlist: { _ in },
                                            onFavorites: { _ in })
        return TMDBBannerView(viewModel: viewModel)
    }
}
