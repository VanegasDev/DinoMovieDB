//
//  LoginView.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 70) {
            Image(R.image.fullLogoColored.name)
            inputViews
        }
        .tmdbActivityIndicator(isAnimating: viewModel.isLoading)
    }
    
    private var inputViews: some View {
        VStack(spacing: 32) {
            textFields
            Button(action: viewModel.loginButtonTap.send) {
                Text(R.string.localization.login_button_title())
                    .tmdbButtonStyleLabel()
            }
            .buttonStyle(TMDBButtonStyle())
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
    
    private var textFields: some View {
        VStack(spacing: 16) {
            TMDBTextField($viewModel.username, placeholder: R.string.localization.login_username_placeholder())
            TMDBTextField($viewModel.password, placeholder: R.string.localization.login_password_placeholder(), isSecureTextField: true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
