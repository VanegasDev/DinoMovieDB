//
//  TVShowDetailView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/3/21.
//

import SwiftUI

let bannerMock = TMDBBannerViewModel(url: nil, title: "NO Title", releaseDate: "-", genderName: "terror", voteAverage: "2", onWatchlist: {_ in}, onFavorites: {_ in})

struct TVShowDetailView: View {
    private let rows = [
        GridItem(.flexible(minimum: 16)),
        GridItem(.flexible(minimum: 16)),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TMDBBannerView(viewModel: bannerMock)
                VStack(alignment: .leading, spacing: 8) {
                    tvShowsDetails
                    overview
                    castingList
                    seasonsList
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(R.color.backgroundColor.name))
//        .tmdbActivityIndicator(isAnimating: viewModel.isLoading)
//        .onAppear(perform: viewModel.fetchDetailsTrigger.send)
    }
    
    private var tvShowsDetails: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Director:")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Text("Director")
                    .font(.system(size: 15))
            }
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                Text("Duration:")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Text("1h 15m")
                    .font(.system(size: 15))
            }
        }
    }
    
    private var overview: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Detail:")
                .font(.system(size: 22))
                .fontWeight(.bold)
            Text("Lorem Ipsum")
                .font(.system(size: 17))
        }
    }
    
    private var castingList: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 6) {
                ForEach(0 ..< 3) { _ in
                    TMDBCastView(url: URL(string: ""), name: "Nombre", description: "Personaje")
                }
            }
        }
    }
    
    private var seasonsList: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 6) {
                ForEach(0 ..< 3) { _ in
                    TMDBSeasonView(url: URL(string: ""), title: "Nombre", description: "Personaje")
                }
            }
        }
    }
}

struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailView()
    }
}
