//
//  TMDBCastView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import SwiftUI
import Kingfisher

struct TMDBCastView: View {
    let url: URL?
    let name: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            KFImage(url)
                .placeholder {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .foregroundColor(.white)
                }
                .resizable()
                .aspectRatio(125/175, contentMode: .fit)
                .frame(height: 175)
                .background(Color(R.color.primarySolid.name))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: Color(R.color.tmdbShadow.name), radius: 10, x: 0, y: 15)
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color(R.color.secondaryColor.name))
            }
        }
        .fixedSize(horizontal: false, vertical: false)
        .frame(width: 125)
    }
}

struct TMDBCastView_Previews: PreviewProvider {
    static var previews: some View {
        TMDBCastView(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Jonah_Hill-4939_%28cropped%29.jpg/220px-Jonah_Hill-4939_%28cropped%29.jpg"),
                     name: "Jonah Hill",
                     description: "Jack Sparrow")
    }
}
