//
//  TMDBTextField.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import SwiftUI

struct TMDBTextField: View {
    @Binding private var text: String
    
    private var placeholder: String
    private var isSecureTextField: Bool
    
    init(_ text: Binding<String>, placeholder: String, isSecureTextField: Bool = false) {
        self._text = text
        self.placeholder = placeholder
        self.isSecureTextField = isSecureTextField
    }
    
    var body: some View {
        textfield
            .padding(.horizontal)
            .tmdbPlaceholder(placeholder, isShowingPlaceholder: text.isEmpty)
            .frame(height: 48)
            .foregroundColor(Color.primaryColor)
            .background(Color.tmdbBackgroundControls)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 2))
            )
    }
    
    private var textfield: some View {
        Group {
            if isSecureTextField {
                SecureField("", text: $text)
            } else {
                TextField("", text: $text)
            }
        }
    }
}

struct TMDBTextField_Previews: PreviewProvider {
    static var previews: some View {
        TMDBTextField(.constant(""), placeholder: "Holup")
            .padding()
    }
}
