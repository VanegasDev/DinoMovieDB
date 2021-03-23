//
//  ProfileView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/19/21.
//

import SwiftUI
import Kingfisher

// TODO: Fix logout button since this is just a temporary one
struct ProfileView: View {
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 38) {
            profile
            Button("Logout") {
                viewModel.logoutTap.send(())
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(Color(R.color.backgroundColor.name))
        .tmdbActivityIndicator(isAnimating: viewModel.isLoading)
        .onAppear(perform: viewModel.fetchInformationOnAppear.send)
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
