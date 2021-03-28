//
//  TMDBItemRateModifier.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import SwiftUI

struct TMDBItemRateModifier: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .font(.system(size: 13))
            .foregroundColor(Color(R.color.primarySolid.name))
            .background(Color(R.color.secondaryColor.name))
            .clipShape(Circle())
    }
}

extension Text {
    func tmdbItemRate(size: CGFloat) -> some View {
        self.modifier(TMDBItemRateModifier(size: size))
    }
}
