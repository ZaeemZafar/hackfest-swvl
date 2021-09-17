//
//  JFResetPasswordViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/11/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFResetPasswordViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var resetPasswordTextField: JFTextField!
    @IBOutlet weak var repeatPasswordTextField: JFTextField!
    @IBOutlet weak var resetButton: JFButton!
    @IBOutlet weak var resetContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK:- Public properties
    var resetCode = ""
    var validator: Validator!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for reset password vc :)")
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
        
        if JFValidator.shared.isValidPassword(text: resetPasswordTextField.text!) && JFValidator.shared.isValidPassword(text: repeatPasswordTextField.text!) {
            
            resetButton.isEnabled = true
            
        } else {
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: JFButton) {
        appReset()
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
    
    @objc func backBarButtonItemTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
        
        validator.add(textField: resetPasswordTextField, rules: [.regex(.password)]) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                self?.show(errorMessage: "Password must be at least 8 characters long and include at least one letter, number, and special character.")
            }
        }
        validator.add(textField: repeatPasswordTextField, rules: [.matches(resetPasswordTextField)]) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                self?.show(errorMessage: "Password does not match.")
            }
        }
        validator.onValidationChange { [weak self] success in
            self?.resetButton.isEnabled = success
        }
    }
    
    func show(errorMessage: String) {
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
    }
    
    func hideErrorMessage() {
        errorLabel.isHidden = true
    }
    
    func setupNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left_arrow_grey"), style: .plain, target: self, action: #selector(backBarButtonItemTapped))
        
        self.title = "Reset Password"
        
        self.navigationController?.navigationBar.tintColor = .black
    }
}

//MARK:- Reset
extension JFResetPasswordViewController {
    
    func appReset() {
        self.view.endEditing(true)
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.updatingPassword, animated: true)
        
        JFWSAPIManager.shared.resetPassword(code: resetCode, password: resetPasswordTextField.text!) {  [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                let tabBarVC = strongSelf.getTabbarVC()
                UIApplication.shared.keyWindow?.swapRootViewControllerWithAnimation(newViewController: tabBarVC, animationType: .push)
                
                // User has also logged-in
                JFSession.shared.setLogInStatus()
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.appReset()
                    }
                }
            }
        }
    }
}
