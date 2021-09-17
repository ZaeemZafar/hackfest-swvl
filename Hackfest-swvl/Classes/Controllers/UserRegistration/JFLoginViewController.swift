//
//  JFLoginViewController.swift
//  JFLoginViewController
//
//  Created by jawad ali on 01/04/2018.
//  Copyright © 2018 jawad ali. All rights reserved.
//

import UIKit

class JFLoginViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var emailTextField: JFTextField!
    @IBOutlet weak var passwordTextField: JFTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: JFButton!
    @IBOutlet weak var enterEmailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordTop: NSLayoutConstraint!
    
    //MARK:- Public properties
    var prefilledEmailAddress = ""
    var validator: Validator!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for login vc :)")
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
    @IBAction func textChanged(_ sender: JFTextField) {
        
        if JFValidator.shared.isValidEmail(text: (emailTextField.text?.normalized)!) && JFValidator.shared.isValidPassword(text: passwordTextField.text!) {
            loginButton.isEnabled = true
            
        } else {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: JFButton) {
        self.view.endEditing(true)
        appLogin()
    }
    
    //MARK:- Helper methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupView() {
        textFieldsSettings()
        setupKeyboardObservers()
        
        if prefilledEmailAddress.isEmpty == false {
            emailTextField.text = prefilledEmailAddress
        }
        
        // Setting initial state of Buttons
        loginButton.isEnabled = false
    }
    
    func setupKeyboardObservers() {
        addKeyboardShowObserver { [weak self] height in
            self?.loginContainerViewBottom.constant = height
            if Devices.iPhone5AndSmallDevices {
                self?.enterEmailTopConstraint.constant = 0
            }
        }
        addKeyboardHideObserver { [weak self] in
            self?.loginContainerViewBottom.constant = 0
            
            if Devices.iPhone5AndSmallDevices {
                self?.enterEmailTopConstraint.constant = 44
            }
            
        }
    }
    
    func textFieldsSettings() {
        validator = Validator(withView: view)
        validator.add(textField: emailTextField, rules: [.regex(.email)]) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                self?.show(errorMessage: "Invalid email or password. Please try again.")
            }
        }
        validator.add(textField: passwordTextField, rules: [.notEmpty]) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                self?.show(errorMessage: "Invalid email or password. Please try again.")
            }
        }
        
        validator.onValidationChange { [weak self] success in
            self?.loginButton.isEnabled = success
        }
    }
    
    func show(errorMessage: String) {
        forgotPasswordTop.constant = 40
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
    }
    
    func hideErrorMessage() {
        forgotPasswordTop.constant = 18
        errorLabel.isHidden = true
    }
    
    func setupNavigation() {
        title = "WELCOME BACK"
        addBackButton()
    }
}

//MARK:- Network calls
extension JFLoginViewController {
    
    func appLogin() {
        let email = emailTextField.text?.normalized ?? ""
        let password = passwordTextField.text!
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.loggingIn, animated: true)
        
        JFWSAPIManager.shared.loginWithEmail(email: email, password: password) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                JFSession.shared.setLogInStatus()
                                
                let tabBarVC = strongSelf.getTabbarVC()
                UIApplication.shared.keyWindow?.swapRootViewControllerWithAnimation(newViewController: tabBarVC, animationType: .push) 
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.appLogin()
                    }
                }
            }
        }
    }
}
