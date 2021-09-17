//
//  JFAlertController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/10/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFAlertController {
    
    class var shared: JFAlertController {
        let shared = JFAlertController()
        return shared
    }
    
//    func presentAlertControllerWiths(alertType: AlertType, sender viewController: UIViewController, completion: SimpleCompletionBlock?) {
//        let vc = UIViewController.getAlertVC()
//        vc.selectedAlertType = alertType
//        vc.completion = completion
//        viewController.present(vc, animated: true, completion: nil)
//    }
//    
//    func presentAlertControllerWith(titleImage: UIImage?, titleLabel: String, descLabel: NSAttributedString, showCrossButton: Bool, doneButtonTitle: String, sender viewController: UIViewController, completion: SimpleCompletionBlock?) {
//        
//        let vc = UIViewController.getAlertVC()
//        
//        vc.titleImg = titleImage
//        vc.titleLbl = titleLabel
//        vc.descriptionLbl = descLabel
//        vc.doneButtonTitle = doneButtonTitle
//        vc.completion = completion
//        vc.showCrossButton = showCrossButton
//        viewController.present(vc, animated: true, completion: nil)
//    }
    
    func presentSendInviteAlertController(sender viewController: UIViewController) {
        let vC = UIViewController.getSendInviteAlertVC()
        vC.modalPresentationStyle = .overCurrentContext
        viewController.present(vC, animated: false, completion: nil)
    }
}


