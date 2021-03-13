//
//  TMDBButtonStyle.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import SwiftUI

// Button style for using in TMDB
struct TMDBButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(R.color.primaryColor.name))
            .foregroundColor(Color(R.color.backgroundColor.name))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

extension View {
    func tmdbButtonStyleLabel() -> some View {
        self.frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color(R.color.primaryColor.name))
    }
}
