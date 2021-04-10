//
//  TMDBProfileOptionView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 4/8/21.
//

import SwiftUI

struct TMDBProfileOptionView: View {
    var text: String
    var systemImage: String
    var foregroundColor: Color = Color(R.color.defaultAccent.name)
    
    var body: some View {
        Label {
            Text(text)
                .tmdbChevronModifier()
        } icon: {
            Image(systemName: systemImage)
                .frame(width: 31)
        }
        .foregroundColor(foregroundColor)
        .frame(height: 40)
    }
}

struct TMDBProfileOptionView_Previews: PreviewProvider {
    static var previews: some View {
        TMDBProfileOptionView(text: "Text", systemImage: "star")
    }
}
