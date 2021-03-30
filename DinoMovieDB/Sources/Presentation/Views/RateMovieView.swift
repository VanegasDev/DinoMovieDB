//
//  RateMovieView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

import SwiftUI

struct RateMovieView: View {
    @State var isMovieRated = true
    
    var body: some View {
        VStack(spacing: 37) {
            VStack(spacing: 16) {
                Text(R.string.localization.item_rate_description("Godzilla"))
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                TMDBStarRateView()
                    .foregroundColor(Color(R.color.tertiaryFixed.name))
            }
            
            if isMovieRated {
                TMDBDoneAlertView()
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(R.color.backgroundColor.name))
    }
}

struct RateMovieView_Previews: PreviewProvider {
    static var previews: some View {
        RateMovieView()
    }
}
