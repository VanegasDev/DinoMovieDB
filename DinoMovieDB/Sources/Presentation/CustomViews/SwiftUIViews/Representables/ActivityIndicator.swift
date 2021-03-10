//
//  ActivityIndicator.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/5/21.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    let isAnimating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = R.color.primaryColor()
        
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

