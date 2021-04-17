//
//  ProfileView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/19/21.
//

import SwiftUI
import Kingfisher

struct TMDBDivider: View {
    var color: Color = Color(R.color.tmdbPlaceholder.name)
    
    var body: some View {
        Divider()
            .background(color)
    }
}

struct ProfileView: View {
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 38) {
            profile
            VStack(alignment: .leading, spacing: 0) {
                TMDBProfileOptionView(text: R.string.localization.profile_favorites_button_title(), systemImage: "heart")
                    .onTapGesture(perform: viewModel.showFavoritesInput.send)
                TMDBDivider()
                TMDBProfileOptionView(text: R.string.localization.profile_watchlist_button_title(), systemImage: "eye")
                    .onTapGesture(perform: viewModel.showWatchlistInput.send)
                TMDBDivider()
                TMDBProfileOptionView(text: R.string.localization.profile_ratings_button_title(), systemImage: "star")
                    .onTapGesture(perform: viewModel.showRatingsInput.send)
                TMDBDivider()
                TMDBProfileOptionView(text: R.string.localization.profile_sign_out_button_title(), systemImage: "arrow.down.left.circle", foregroundColor: .red)
                    .onTapGesture(perform: viewModel.logoutInput.send)
            }
            .font(.body)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(Color(R.color.tmdbBackgroundControls.name))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(Color(R.color.backgroundColor.name))
        .tmdbActivityIndicator(isAnimating: viewModel.isLoading)
        .onAppear(perform: viewModel.fetchInformationInput.send)
    }
    
    private var profile: some View {
        HStack(alignment: .top, spacing: 20) {
            KFImage(URL(string: viewModel.avatarPath))
                .placeholder {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .foregroundColor(.white)
                }
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .background(Color.black)
                .clipShape(Circle())
                .shadow(color: Color(R.color.tmdbShadow.name), radius: 10, x: 0, y: 5)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(Color(R.color.defaultAccent.name))
                Text(viewModel.username)
                    .font(.system(size: 18))
                    .foregroundColor(Color(R.color.secondarySolid.name))
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
