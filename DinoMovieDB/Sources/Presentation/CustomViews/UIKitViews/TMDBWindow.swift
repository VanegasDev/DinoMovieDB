//
//  TMDBWindow.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/7/21.
//

import UIKit

enum ApplicationState {
    case logged
    case logout
    case guestMode
}

class TMDBWindow: UIWindow {
    func start(on state: ApplicationState) {
        switch state {
        case .logged:
            startOnLoggedState()
        case .logout:
            startOnLogoutState()
        default:
            print("Not Handled")
            break
        }
    }
    
    func startOnLoggedState() {
        let viewController = HomeViewController()
        let transitionOption =  UIWindow.TransitionOptions(direction: .fade, style: .easeOut)
        transitionOption.duration = 0.4
        
        set(rootViewController: viewController, options: transitionOption)
    }
    
    func startOnLogoutState() {
        let viewController = LoginViewController()
        let transitionOption =  UIWindow.TransitionOptions(direction: .fade, style: .easeOut)
        transitionOption.duration = 0.4
        
        set(rootViewController: viewController, options: transitionOption)
    }
}
