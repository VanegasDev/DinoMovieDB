//
//  MovieDetailView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import SwiftUI

struct MovieDetailView: View {
    private let rows = [
        GridItem(.flexible(minimum: 16)),
        GridItem(.flexible(minimum: 16)),
    ]
    
    private var viewModel: MovieDetailViewModel
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TMDBBannerView(viewModel: viewModel.bannerViewModel)
                VStack(alignment: .leading, spacing: 8) {
                    movieDetails
                    overview
                    casting
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(R.color.backgroundColor.name))
    }
    
    private var movieDetails: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Director:")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Text(viewModel.directorName)
                    .font(.system(size: 15))
            }
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                Text("Duration:")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Text(viewModel.duration)
                    .font(.system(size: 15))
            }
        }
    }
    
    private var overview: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Overview")
                .font(.system(size: 22))
                .fontWeight(.bold)
            Text(viewModel.overview)
                .font(.system(size: 17))
        }
    }
    
    private var casting: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Cast")
                .font(.system(size: 22))
                .fontWeight(.bold)
            castingList
                .font(.system(size: 17))
        }
    }
    
    private var castingList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 6) {
                ForEach(viewModel.cast) { actor in
                    TMDBCastView(url: URL(string: "\(TMDBConfiguration.imageBasePath)\(actor.profilePath ?? "")"), name: actor.name, description: actor.character)
                }
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieDetailView(viewModel: MovieDetailViewModel())
        }
    }
}
