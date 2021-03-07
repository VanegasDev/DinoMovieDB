//
//  Color+Extensions.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import SwiftUI

extension Color {
    static let backgroundColor: Color = Color("background-color")
    static let primaryColor: Color = Color("primary-color")
    static let tmdbBackgroundControls: Color = Color("tmdb-background-controls")
    static let tmdbPlaceholder: Color = Color("tmdb-placeholder")
    static let secondaryColor: Color = Color("secondary-color")
    static let primarySolid: Color = Color("primary-solid")
}

extension UIColor {
    static let backgroundColor: UIColor = UIColor(named: "background-color") ?? UIColor()
    static let primaryColor: UIColor = UIColor(named: "primary-color") ?? UIColor()
    static let tmdbBackgroundControls: UIColor = UIColor(named: "tmdb-background-controls") ?? UIColor()
    static let tmdbPlaceholder: UIColor = UIColor(named: "tmdb-placeholder") ?? UIColor()
    static let secondaryColor: UIColor = UIColor(named: "secondary-color") ?? UIColor()
    static let primarySolid: UIColor = UIColor(named: "primary-solid") ?? UIColor()
}
