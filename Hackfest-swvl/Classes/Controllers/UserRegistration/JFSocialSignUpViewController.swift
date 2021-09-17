//
//  JFSocialSignUpViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/11/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFSocialSignUpViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for social signup vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:- User actions
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
       if self.navigationController?.popToViewController(vcClass: JFSocialLoginViewController.self) ?? false {
            // already navigated
        } else {
            let socialLoginVC = getSocialLoginVC()
            self.navigationController?.pushViewController(socialLoginVC, animated: true)
        }
        
    }

    //MARK:- Helper methods
    func signinWithFacebook() {

    }
    
}
