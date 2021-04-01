//
//  TMDBDoneAlertView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

import SwiftUI

struct TMDBDoneAlertView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .frame(height: 48)
            Text(R.string.localization.done_alert_title())
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 28)
        .background(Color(R.color.tertiaryColor.name))
        .foregroundColor(Color(R.color.backgroundColor.name))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct TMDBDoneAlertView_Previews: PreviewProvider {
    static var previews: some View {
        TMDBDoneAlertView()
    }
}
