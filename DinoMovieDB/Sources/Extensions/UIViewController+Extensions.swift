//
//  UIViewController+Extensions.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/4/21.
//

import SwiftUI
import TinyConstraints

extension UIViewController {
    func addHosting<T: SwiftUI.View>(_ view: T, backgroundColor: UIColor? = R.color.backgroundColor()) {
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.backgroundColor = backgroundColor
        
        add(child: hostingController)
    }
    
    private func add(child viewController: UIViewController) {
        addChild(viewController)
        
        view.addSubview(viewController.view)
        viewController.view.edgesToSuperview()
        viewController.didMove(toParent: self)
    }
}
