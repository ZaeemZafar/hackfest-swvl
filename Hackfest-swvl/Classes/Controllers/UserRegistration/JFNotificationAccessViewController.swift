//
//  JFNotificationAccessViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/17/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit
import UserNotifications

class JFNotificationAccessViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var allowButton: JFButton!
    @IBOutlet weak var notAllowButton: UIButton!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for notification access vc :)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
    }
    
    //MARK:- User actions
    @IBAction func allowButtonTapped(_ sender: JFButton) {
        allowTapped()
    }
    
    @IBAction func notAllowButtonTapped(_ sender: UIButton) {
        updatePrefereceToServerAndContinueSignup(notificationEnabled: false)
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "NOTIFICATIONS"
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func navigateToNextScreen() {
        let vc = getLocationAccessVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func allowTapped() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (success, error) in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                if success {
                    strongSelf.updatePrefereceToServerAndContinueSignup(notificationEnabled: success)
                    JFNotificationManager.shared.configure()
                    
                } else {
                    UIAlertController.showAlertWithSettingsPrompt(title: "Hackfest-swvl", message: "Push Notifications are turned off for Hackfest-swvl app from system settings, you can change it from Settings", fromViewController: strongSelf)
                }
            }
        }
    }
}

//MARK:- Network calls
extension JFNotificationAccessViewController {
    func updatePrefereceToServerAndContinueSignup(notificationEnabled: Bool) {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.updatingPreference, animated: true)
        
        JFWSAPIManager.shared.updateNotificationPreference(notificationEnabled: notificationEnabled) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                // Developer's Note: This needs to be changed
                strongSelf.navigateToNextScreen()//signupUser() replace with other api flow
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.updatePrefereceToServerAndContinueSignup(notificationEnabled: notificationEnabled)
                    }
                }
            }
        }
    }
}
