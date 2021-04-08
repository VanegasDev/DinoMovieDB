//
//  TVShowDetailView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/3/21.
//

import SwiftUI

struct TVShowDetailView: View {
    private let rows = [
        GridItem(.flexible(minimum: 16)),
        GridItem(.flexible(minimum: 16)),
    ]
    
    @ObservedObject private var viewModel: TVShowDetailViewModel
    
    init(viewModel: TVShowDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TMDBBannerView(viewModel: viewModel.bannerViewModel)
                VStack(alignment: .leading, spacing: 8) {
                    tvShowsDetails
                    overview
                    VStack(alignment: .leading, spacing: 0) {
                        Text(R.string.localization.show_detail_cast_title())
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        castingList
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(R.string.localization.show_detail_seasons_title())
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        seasonsList
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(R.color.backgroundColor.name))
        .tmdbActivityIndicator(isAnimating: viewModel.isLoading)
        .onAppear(perform: viewModel.fetchDetailsInput.send)
    }
    
    private var tvShowsDetails: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(R.string.localization.show_detail_director_title())
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Text(viewModel.creator)
                    .font(.system(size: 15))
            }
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                Text(R.string.localization.show_detail_duration_title())
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Text(viewModel.duration)
                    .font(.system(size: 15))
            }
        }
    }
    
    private var overview: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(R.string.localization.show_detail_overview_title())
                .font(.system(size: 22))
                .fontWeight(.bold)
            Text(viewModel.overview)
                .font(.system(size: 17))
        }
    }
    
    private var castingList: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 6) {
                ForEach(viewModel.cast) { actor in
                    TMDBCastView(url: URL(string: "\(TMDBConfiguration.imageBasePath)\(actor.profilePath ?? "")"), name: actor.name, description: actor.character)
                }
            }
        }
    }
    
    private var seasonsList: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 6) {
                ForEach(viewModel.seasons) { season in
                    TMDBSeasonView(url: URL(string: "\(TMDBConfiguration.imageBasePath)\(season.posterPath ?? "")"),
                                   title: R.string.localization.show_detail_season_number("\(season.seasonNumber)"),
                                   description: R.string.localization.show_detail_season_episodes("\(season.numberOfEpisodes)"))
                }
            }
        }
    }
}

struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailView(viewModel: TVShowDetailViewModel())
    }
}
