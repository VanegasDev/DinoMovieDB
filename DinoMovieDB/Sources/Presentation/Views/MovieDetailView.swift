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
    // TODO: Erase This - Just for testing purposes
    private let bannerViewModel = TMDBBannerViewModel(url: URL(string: "https://elainescottphotographydotcom.files.wordpress.com/2016/01/yukon-mountain-scene.png"),
                                        title: "Godzilaa",
                                        releaseDate: "June 23, 2021",
                                        genderName: "Terror",
                                        voteCount: 15,
                                        isOnWatchlist: true,
                                        isOnFavorites: true,
                                        onWatchlist: { _ in },
                                        onFavorites: { _ in })
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TMDBBannerView(viewModel: bannerViewModel)
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
                Text("Tim Burton")
                    .font(.system(size: 15))
            }
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                Text("Duration:")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Text("1h 47m")
                    .font(.system(size: 15))
            }
        }
    }
    
    private var overview: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Overview")
                .font(.system(size: 22))
                .fontWeight(.bold)
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
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
                ForEach(0 ..< 15) { _ in
                    TMDBCastView(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Jonah_Hill-4939_%28cropped%29.jpg/220px-Jonah_Hill-4939_%28cropped%29.jpg"),
                                 name: "Jonah Hill",
                                 description: "Jack Sparrow")
                }
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieDetailView()
            MovieDetailView()
                .preferredColorScheme(.dark)
        }
    }
}
