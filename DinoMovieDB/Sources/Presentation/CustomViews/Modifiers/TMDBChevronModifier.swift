//
//  TMDBChevronModifier.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/8/21.
//

import SwiftUI

struct TMDBChevronModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(Color(R.color.tmdbPlaceholder.name))
        }
    }
}

extension Text {
    func tmdbChevronModifier() -> some View {
        self.modifier(TMDBChevronModifier())
    }
}
