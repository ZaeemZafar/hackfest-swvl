//
//  JFChangeEmailViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/9/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFChangeEmailViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var emailTextField: JFTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK:- Public properties
    var profileInfo = ProfileInfo()
    var validator: Validator!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for change email vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = profileInfo.email
        setupNavigation()
        textFieldsSettings()
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        self.navigationItem.title = "EMAIL"
        
        let rightButtomItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        rightButtomItem.tintColor = UIColor.jfDarkGray
        rightButtomItem.isEnabled = false
        customRightButton(button: rightButtomItem)
        
        addBackButton()
    }
    
    func textFieldsSettings() {
        validator = Validator(withView: view)
        
        validator.add(textField: emailTextField, rules: [.regex(.email)]) { [weak self] success in
            if success {
                //self.hideErrorMessage()
            } else {
                //self.show(errorMessage: "Psst. Password must include at least one letter, number and special character.")
            }
        }
        validator.onValidationChange { [weak self] success in
            self?.navigationItem.rightBarButtonItem?.isEnabled = success
        }
    }
    
    func show(errorMessage: String) {
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
    }
    
    func hideErrorMessage() {
        errorLabel.isHidden = true
    }
    
    @objc func saveButtonTapped() {
        self.view.endEditing(true)
        updateEmail()
    }
}

//MARK:- Network calls
extension JFChangeEmailViewController {
    func updateEmail() {
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.updatingEmail, animated: true)
        
        JFWSAPIManager.shared.updateEmail(email: emailTextField.text!) {  [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                JFAlertViewController.presentAlertController(with: .changeEmail(email: strongSelf.emailTextField.text ?? ""), fromViewController: strongSelf.tabBarController, completion: { success in
                    if success {
                        strongSelf.navigationController?.popViewController(animated: true)
                        
                        if (strongSelf.systemCanSendEmail()) {
                            // Open iOS mail application
                            strongSelf.openMailClient()
                        }
                    }
                })
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.updateEmail()
                    }
                }
            }
        }
        
    }
    
    @discardableResult
    private func openMailClient() -> Bool {
        let mailURL = URL(string: "message://")!
        
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            return true
        }
        
        return false
    }
}
