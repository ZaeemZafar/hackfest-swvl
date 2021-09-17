//
//  JFChangePasswordViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/9/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFChangePasswordViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var currentPasswordTextField: JFTextField!
    @IBOutlet weak var newPasswordTextField: JFTextField!
    @IBOutlet weak var newPasswordAgainTextField: JFTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK:- Public properties
    var validator: Validator!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for change password vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        textFieldsSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- Helper methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupNavigation() {
        self.navigationItem.title = "PASSWORD"
        
        let rightButtomItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        rightButtomItem.tintColor = UIColor.jfDarkGray
        rightButtomItem.isEnabled = false
        customRightButton(button: rightButtomItem)
        
        addBackButton()
    }
    
    
    func textFieldsSettings() {
        validator = Validator(withView: view)
        
        validator.add(textField: currentPasswordTextField, rules: [.regex(.password)])
    
        validator.add(textField: newPasswordTextField, rules: [.regex(.password), .notMatchesTo(currentPasswordTextField)]) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                if self?.currentPasswordTextField.text == self?.newPasswordTextField.text {
                    self?.show(errorMessage: "New password and current password cannot be same.")
                } else {
                    self?.show(errorMessage: "Password must be at least 8 characters long and include at least one letter, number, and special character.")
                }
            }
        }
    
        validator.add(textField: newPasswordAgainTextField, rules: [.matches(newPasswordTextField)]) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                self?.show(errorMessage: "Password does not match.")
            }
        }
        validator.onValidationChange { [weak self] success in
            if self?.currentPasswordTextField.text != self?.newPasswordTextField.text && self?.currentPasswordTextField.text != self?.newPasswordAgainTextField.text {
                
                self?.navigationItem.rightBarButtonItem?.isEnabled = success
            }
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
        changesConfirmation()
    }
}

//MARK:- Network calls
extension JFChangePasswordViewController {
    
    func changesConfirmation() {
        JFAlertViewController.presentAlertController(with: .changePassword, fromViewController: self.tabBarController) { success in
            if success {
                self.changePassword()
            }
        }
    }
    
    func changePassword() {
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.updatingPassword, animated: true)
        
        JFWSAPIManager.shared.changePassword(oldPassword: currentPasswordTextField.text!, newPassword: newPasswordAgainTextField.text!) {  [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.tabBarController?.view)!, title: "Saved", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                    strongSelf.navigationController?.popViewController(animated: true)
                })
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.changePassword()
                    }
                }
            }
        }
    }
}
