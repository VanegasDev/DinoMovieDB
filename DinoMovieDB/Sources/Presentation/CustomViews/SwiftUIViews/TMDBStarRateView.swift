//
//  TMDBStarRateView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

import SwiftUI
import Combine

struct TMDBStarRateView: View {
    // MARK: Output
    @Binding var numberOfChosenStars: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(0 ..< 5) { index in
                makeStar(isActive: index < numberOfChosenStars)
                    .onTapGesture { numberOfChosenStars = index + 1 }
            }
            
            Image(systemName: "multiply.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .onTapGesture(perform: resetRating)
                .foregroundColor(Color(R.color.tmdbPlaceholder.name))
        }
    }
    
    private func makeStar(isActive: Bool) -> some View {
        Image(systemName: isActive ? "star.fill" : "star")
            .resizable()
            .scaledToFit()
            .frame(width: 31, height: 29)
    }
    
    private func resetRating() {
        numberOfChosenStars = 0
    }
}

struct TMDBStarRateView_Previews: PreviewProvider {
    static var previews: some View {
        TMDBStarRateView(numberOfChosenStars: .constant(2))
    }
}
