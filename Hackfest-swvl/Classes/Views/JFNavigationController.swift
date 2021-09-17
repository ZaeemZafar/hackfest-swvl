//
//  JFNavigationController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/4/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting navigation bar transparent
        //navigationBar.setBackgroundImage(UIImage(), for: .default)
    
        self.navigationController?.popToViewController(vcClass: JFProfileViewController.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("JFNav willappear")
    }
    
    convenience init() {
        self.init(navigationBarClass: JFNavigationBar.self, toolbarClass: nil)
    }
    
}

extension UINavigationController {
    @discardableResult
    func popToViewController<T>(vcClass: T.Type, animated: Bool = true) -> Bool {

        for vc in viewControllers {
            if type(of: vc) == vcClass {
                print("It is in stack")
                self.popViewController(animated: animated)
                return true
            }
        }
        
        
        return false
    }
    
    func pushViewControllers(_ inViewControllers: [UIViewController], animated: Bool) {
        var stack = self.viewControllers
        stack.append(contentsOf: inViewControllers)
        self.setViewControllers(stack, animated: true)
    }
}


