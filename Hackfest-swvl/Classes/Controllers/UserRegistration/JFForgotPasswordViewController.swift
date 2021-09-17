//
//  JFForgotPasswordViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/9/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFForgotPasswordViewController: JFViewController, KeyboardProtocol {

    //MARK:- IBOutlets
    @IBOutlet weak var emailTextField: JFTextField!
    @IBOutlet weak var resetButton: JFButton!
    @IBOutlet weak var resetContainerViewBottom: NSLayoutConstraint!
    
    //MARK:- Public properties
    var validator: Validator!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for forgot password vc :)")
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
        
        if JFValidator.shared.isValidEmail(text: emailTextField.text!)  {
            resetButton.isEnabled = true
            
        } else {
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: JFButton) {
        resetPassword()
    }
    
    //MARK:- Helper methods
    func setupView() {
        textFieldsSettings()
        setupKeyboardObservers()
        
        // Setting initial state of Buttons
        resetButton.isEnabled = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupKeyboardObservers() {
        addKeyboardShowObserver { [weak self] height in
            self?.resetContainerViewBottom.constant = height
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.resetContainerViewBottom.constant = 0
        }
    }
    
    func textFieldsSettings() {
        validator = Validator(withView: view)
       
        validator.add(textField: emailTextField, rules: [.regex(.email)])
        
        validator.onValidationChange { [weak self] success in
            self?.resetButton.isEnabled = success
        }
    }
    
    func setupNavigation() {
        title = "FORGOT PASSWORD"
        addBackButton()
    }
}

//MARK:- Network calls
extension JFForgotPasswordViewController {
    
    func resetPassword() {
        view.endEditing(true)
            let email = emailTextField.text?.normalized ?? ""
            
            MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.sendingEmail, animated: true)
            
            JFWSAPIManager.shared.forgotPassword(email: email) { [weak self] (success, errorMessage) in
                guard let strongSelf = self else { return }
                MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
                
                if success {
                    JFAlertViewController.presentAlertController(with: .forgotPassword, fromViewController: strongSelf) { success in
                        if success {
                            strongSelf.navigationController?.popViewController(animated: true)
                            
                            if (strongSelf.systemCanSendEmail()) {
                                // Open iOS mail application
                                strongSelf.openMailClient()
                            }
                        }
                    }
                } else {
                    let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                    
                    JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                        if success {
                            strongSelf.resetPassword()
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
