//
//  JFVerificationViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/12/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFVerificationViewController: JFViewController, KeyboardProtocol {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneTextField: JFTextField!
    @IBOutlet weak var nextButton: JFButton!
    @IBOutlet weak var labelTop: NSLayoutConstraint!
    @IBOutlet weak var nextContainerViewBottom: NSLayoutConstraint!
    
    //MARK:- Public properties
    var validator: Validator!
    var signUpUser: JFSignUpUser!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for verification vc :)")
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
        
    }
    
    @IBAction func nextButtonTapped(_ sender: JFButton) {
        nxtButtonTapped()
    }
    
    //MARK:- Helper methods
    func setupView() {
        textFieldsSettings()
        setupKeyboardObservers()
        
        // Setting initial state of Buttons
        nextButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldsSettings() {
        validator = Validator(withView: view)
        validator.add(textField: phoneTextField, rules: [.phoneNumber, .maxLength(16), .minLength(16)])
        
        validator.onValidationChange {[weak self] success in
            self?.nextButton.isEnabled = success
        }
    }
    
    func setupKeyboardObservers() {
        
        addKeyboardShowObserver { [weak self] height in
            self?.nextContainerViewBottom.constant = height
            if Devices.iPhone5AndSmallDevices {
                self?.labelTop.constant = 0
            }
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.nextContainerViewBottom.constant = 0
            
            if Devices.iPhone5AndSmallDevices {
                self?.labelTop.constant = 80
            }
        }
    }
    
    func setupNavigation() {
        title = "VERIFICATION"
        addBackButton()
    }
}


//MARK:- Network calls
extension JFVerificationViewController {
    func nxtButtonTapped() {
        
        self.view.endEditing(true)
        
        let trimmedPhoneNumber = self.phoneTextField.text?.extractNumbers() ?? ""
        let countryCode = "+\(JFUtility.getCountryCode() ?? "1")"
        let completePhoneNumber = countryCode + trimmedPhoneNumber
        self.signUpUser.phoneNumber = completePhoneNumber
        
        
        if (JFAppTarget.current == .development || JFAppTarget.current == .qa) {
            let vc = getEnterCodeVC()
            vc.code = "0000"
            vc.signUpUser = self.signUpUser
            
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.sendingVerificationCode, animated: true)
        
        JFWSAPIManager.shared.checkPhoneNumberExists(phoneNumber: completePhoneNumber) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            
            if (success) {
                
                JFWSAPIManager.shared.sendTwillioVerificationCode(phoneNumber: completePhoneNumber) { [weak self] (success, errorMessage, code) in
                    guard let strongSelf = self else { return }
                    MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
                    
                    if success {
                        let vc = strongSelf.getEnterCodeVC()
                        vc.code = code
                        vc.signUpUser = strongSelf.signUpUser
                        
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        UIAlertController.showOkayAlert(inViewController: strongSelf, message: errorMessage ?? "")
                    }
                }
                
            } else {
                MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
                
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.nxtButtonTapped()
                    }
                }
            }
        }
    }
}

