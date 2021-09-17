//
//  JFTabbarViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/16/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var fromSignUpProcess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("Deinit called on \(String(describing: JFTabbarViewController.self))")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
        rootView.popToRootViewController(animated: true)
    }
    
}
