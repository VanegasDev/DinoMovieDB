//
//  TMDBActivityIndicatorModifier.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/5/21.
//

import SwiftUI

struct TMDBActivityIndicatorModifier: ViewModifier {
    let isAnimating: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ActivityIndicator(isAnimating: isAnimating)
        }
    }
}

extension View {
    func tmdbActivityIndicator(isAnimating: Bool) -> some View {
        self.modifier(TMDBActivityIndicatorModifier(isAnimating: isAnimating))
    }
}
