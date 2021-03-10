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
                Text("Login")
                    .tmdbButtonStyleLabel()
            }
            .buttonStyle(TMDBButtonStyle())
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
    
    private var textFields: some View {
        VStack(spacing: 16) {
            TMDBTextField($viewModel.username, placeholder: "Username")
            TMDBTextField($viewModel.password, placeholder: "Password", isSecureTextField: true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
