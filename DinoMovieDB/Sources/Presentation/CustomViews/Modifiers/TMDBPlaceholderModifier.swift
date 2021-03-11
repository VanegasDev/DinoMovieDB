//
//  TMDBPlaceholderModifier.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import SwiftUI

struct TMDBPlaceholderModifier: ViewModifier {
    let placeholder: String
    let isShowingPlaceholder: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if isShowingPlaceholder {
                Text(placeholder)
                    .foregroundColor(Color(R.color.tmdbPlaceholder.name))
                    .padding(.horizontal)
            }
            
            content
        }
    }
}

extension View {
    func tmdbPlaceholder(_ text: String, isShowingPlaceholder: Bool) -> some View {
        self.modifier(TMDBPlaceholderModifier(placeholder: text, isShowingPlaceholder: isShowingPlaceholder))
    }
}
