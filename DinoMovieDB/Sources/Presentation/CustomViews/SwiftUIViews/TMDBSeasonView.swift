//
//  TMDBSeasonView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/3/21.
//

import SwiftUI
import Kingfisher

struct TMDBSeasonView: View {
    var url: URL?
    var title: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            KFImage(url)
                .placeholder {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                .resizable()
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                Text(description)
                    .font(.system(size: 13))
            }
            .padding(.horizontal, 5)
            .padding(.bottom)
        }
        .foregroundColor(.white)
        .background(Color(R.color.primarySolid.name))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color(R.color.tmdbShadow.name), radius: 10, x: 0, y: 5)
        .aspectRatio(129/201, contentMode: .fit)
        .frame(height: 201)
    }
}

struct TMDBSeasonView_Previews: PreviewProvider {
    static var previews: some View {
        TMDBSeasonView(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/8d/Official_portrait_of_Dr_Luke_Evans_MP_crop_2.jpg"), title: "Title", description: "Description")
    }
}
