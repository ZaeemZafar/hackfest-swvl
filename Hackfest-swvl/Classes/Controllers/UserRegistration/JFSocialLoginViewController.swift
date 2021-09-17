//
//  JFSocialLoginViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/4/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFSocialLoginViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for social login :)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK:- User actions
    @IBAction func signUpTapped(_ sender: Any) {
        if self.navigationController?.popToViewController(vcClass: JFSocialSignUpViewController.self) ?? false {
            // already navigated
        } else {
            let socialSignupVC = getSocialSignUpVC()
            self.navigationController?.pushViewController(socialSignupVC, animated: true)
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        
    }
    
    //MARK:- Helper methods
   
}
