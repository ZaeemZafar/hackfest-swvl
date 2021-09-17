//
//  JFViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/4/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

// @IBDesignable
class JFViewController: UIViewController {
    
    @IBInspectable var showNavigation: Bool = false {
        didSet {
            if showNavigation {
                navigationController?.setNavigationBarHidden(false, animated: false)
            }
        }
    }
    
    @objc func popViewController() {
        
        // Developer's Note: We have implemented custom behaviour of back button as required by application use-cases
        if let _ = navigationController?.popViewController(animated: true) {
            // Has popped successfully
        } else {
            // Either its root view controller OR its being presented
            // Dimiss if presented modally
            if (self.isModal()) {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Do nothing for now
            }
        }
        
    }
    
    func addBackButton() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left_arrow_grey"), style: .plain, target: self, action: #selector(popViewController))
    }
    
    func customRightButton(button: UIBarButtonItem) {
        button.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.jfLightGray,
            NSAttributedStringKey.font: UIFont.normal(fontSize: 14.0)
            ], for: UIControlState.disabled)
        button.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.jfDarkGray,
            NSAttributedStringKey.font: UIFont.normal(fontSize: 14.0)
            ], for: UIControlState.normal)
        button.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.jfDarkGray,
            NSAttributedStringKey.font: UIFont.normal(fontSize: 14.0)
            ], for: UIControlState.highlighted)
        self.navigationItem.rightBarButtonItem = button
    }
    
    func customLeftButton(button: UIBarButtonItem) {
        button.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont.normal(fontSize: 14.0)
            ], for: .normal)
        button.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont.normal(fontSize: 14.0)
            ], for: UIControlState.highlighted)
        self.navigationItem.leftBarButtonItem = button
    }
    
    func setNavTitle(title: String) {
       self.navigationItem.title = title.uppercased()
    }
}
