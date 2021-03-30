//
//  TMDBItemRateModifier.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/27/21.
//

import SwiftUI

struct TMDBItemRateModifier: ViewModifier {
    let size: CGFloat
    let fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .font(.system(size: fontSize))
            .foregroundColor(Color(R.color.primarySolid.name))
            .background(Color(R.color.secondaryColor.name))
            .clipShape(Circle())
    }
}

extension Text {
    func tmdbItemRate(size: CGFloat, fontSize: CGFloat = 13, fontWeight: Font.Weight = .regular) -> some View {
        self.fontWeight(fontWeight)
            .modifier(TMDBItemRateModifier(size: size, fontSize: fontSize))
    }
}
