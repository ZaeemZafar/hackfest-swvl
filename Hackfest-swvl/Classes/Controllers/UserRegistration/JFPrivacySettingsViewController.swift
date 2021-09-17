//
//  JFPrivacySettingsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/17/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFPrivacySettingsViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var privacyButtons: [JFCategoryButton]!
    @IBOutlet weak var nextButton: JFButton!
    
    //MARK:- Public properties
    var signUpUser: JFSignUpUser!

    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for privacy settings vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- User actions
    @IBAction func everyoneButtonTapped(_ sender: JFCategoryButton) {
        sender.select = true
        privacyButtons[1].select = false
        self.signUpUser.isPublicProfile = true
        nextButton.isEnabled = true
    }
    
    @IBAction func onlyPeopleButtonTapped(_ sender: JFCategoryButton) {
        sender.select = true
        privacyButtons[0].select = false
        self.signUpUser.isPublicProfile = false
        nextButton.isEnabled = true
    }
    
    @IBAction func nextButtonTapped(_ sender: JFButton) {
        signupUser()
    }
    
    //MARK:- Helper methods
    func setupView() {
        
        // Setting initial state of Buttons
        nextButton.isEnabled = false
    }
    
    func setupNavigation() {
        title = "PRIVACY SETTINGS"
        addBackButton()
    }
    
    func navigateToNextScreen() {
        let vc = getNotificationAccessVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func signupUser() {
        ///////please remove it later///////
        signUpUser.locationEnabled = false
        signUpUser.notificationsEnabled = false
        
        if signUpUser.facebookID.isEmpty {
            self.sendSignupRequest()
            
        } else {
            self.sendFacebookSignupRequest()
        }
    }
}

//MARK:- Network calls
extension JFPrivacySettingsViewController {
    func sendSignupRequest() {
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.signingUp, animated: true)
        
        JFWSAPIManager.shared.signUpWithInfo(userInfo: self.signUpUser) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                JFSession.shared.setLogInStatus()
                
                strongSelf.navigateToNextScreen()
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.sendSignupRequest()
                    }
                }
            }
        }
    }
    
    func sendFacebookSignupRequest() {
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.signingUp, animated: true)
        
        JFWSAPIManager.shared.signUpFacebookWithInfo(userInfo: self.signUpUser) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                JFSession.shared.setLogInStatus()
                
                strongSelf.navigateToNextScreen()
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.sendFacebookSignupRequest()
                    }
                }
            }
        }
    }
}
