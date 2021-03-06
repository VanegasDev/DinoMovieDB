//
//  TMDBButtonStyle.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import SwiftUI

struct TMDBButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.primaryColor)
            .foregroundColor(.backgroundColor)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

extension View {
    func tmdbButtonStyleLabel() -> some View {
        self.frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.primaryColor)
    }
}
