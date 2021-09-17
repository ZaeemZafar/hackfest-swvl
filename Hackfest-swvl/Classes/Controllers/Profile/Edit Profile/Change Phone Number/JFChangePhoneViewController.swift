//
//  JFChangePhoneViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/9/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFChangePhoneViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var enterPhonetextField: JFTextField!
    
    //MARK:- Public properties
    var validator: Validator!
    var userInfo = ProfileInfo()
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for change phone vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterPhonetextField.text = userInfo.phone
        setupNavigation()
        textFieldsSettings()
    }
    
    //MARK:- Helper methods
    func textFieldsSettings() {
        validator = Validator(withView: view)
        validator.add(textField: enterPhonetextField, rules: [.phoneNumber, .maxLength(16), .minLength(16)])
        
        validator.onValidationChange { [weak self] success in
            self?.navigationItem.rightBarButtonItem?.isEnabled = success
        }
    }
    
    func setupNavigation() {
        self.navigationItem.title = "PHONE"
        
        let rightButtomItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        rightButtomItem.tintColor = UIColor.jfDarkGray
        rightButtomItem.isEnabled = false
        customRightButton(button: rightButtomItem)
        
        addBackButton()
    }
    
    @objc func saveButtonTapped() {
        self.view.endEditing(true)
        verifyCode()
    }
}

//MARK:- Network calls
extension JFChangePhoneViewController {
    func verifyCode() {
        let trimmedPhoneNumber = self.enterPhonetextField.text?.extractNumbers() ?? ""
        let countryCode = "+\(JFUtility.getCountryCode() ?? "1")"
        let completePhoneNumber = countryCode + trimmedPhoneNumber
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.sendingVerificationCode, animated: true)
        
        
        JFWSAPIManager.shared.sendTwillioVerificationCode(phoneNumber: completePhoneNumber) { [weak self] (success, errorMessage, code) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                let vc = strongSelf.getChangePhoneEnterCodeVC()
                vc.code = code
                vc.phoneNumber = completePhoneNumber
                vc.userInfo = strongSelf.userInfo
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.verifyCode()
                    }
                }
            }
        }
    }
}
