//
//  UIAlertController+Extensions.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/10/21.
//

import UIKit

extension UIAlertController {
    // Error alert
    static func errorAlert(title: String = R.string.localization.alert_error_title(), description: String, completion: ((UIAlertAction) -> Void)?  = nil) -> UIAlertController {
        let controller = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let action1 = UIAlertAction(title: R.string.localization.alert_ok_button(), style: .cancel, handler: completion)
        
        controller.addAction(action1)
        
        return controller
    }
    
    // Custom Yes No Alert
    static func customAlert(title: String,
                            description: String,
                            yesTitle: String,
                            noTitle: String,
                            yesAction: ((UIAlertAction) -> Void)? = nil,
                            noAction: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let controller = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let action1 = UIAlertAction(title: yesTitle, style: .default, handler: yesAction)
        let action2 = UIAlertAction(title: noTitle, style: .cancel, handler: noAction)
        
        controller.addAction(action1)
        controller.addAction(action2)
        
        return controller
    }
    
    // Action Sheet Builder Function
    static func customActionSheet(title: String, message: String? = nil, actions: [UIAlertAction]) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { controller.addAction($0) }
        
        return controller
    }
}
