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
    private var isAutocorrectionDisabled: Bool
    private var autocapitalizationStyle: UITextAutocapitalizationType
    
    init(_ text: Binding<String>,
         placeholder: String,
         isSecureTextField: Bool = false,
         isAutocorrectionDisabled: Bool = false,
         autocapitalizationStyle: UITextAutocapitalizationType = .sentences) {
        self._text = text
        self.placeholder = placeholder
        self.isSecureTextField = isSecureTextField
        self.isAutocorrectionDisabled = isAutocorrectionDisabled
        self.autocapitalizationStyle = autocapitalizationStyle
    }
    
    var body: some View {
        textfield
            .disableAutocorrection(isAutocorrectionDisabled)
            .autocapitalization(autocapitalizationStyle)
            .padding(.horizontal)
            .tmdbPlaceholder(placeholder, isShowingPlaceholder: text.isEmpty)
            .frame(height: 48)
            .foregroundColor(Color(R.color.primaryColor.name))
            .background(Color(R.color.tmdbBackgroundControls.name))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(R.color.primaryColor.name), style: StrokeStyle(lineWidth: 2))
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
