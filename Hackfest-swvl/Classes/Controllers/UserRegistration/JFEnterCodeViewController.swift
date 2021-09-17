//
//  JFEnterCodeViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/15/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFEnterCodeViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet var digitTextFields: [UITextField]!
    @IBOutlet weak var nextButton: JFButton!
    @IBOutlet weak var invalidView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var labelTop: NSLayoutConstraint!
    @IBOutlet weak var nextContainerBottom: NSLayoutConstraint!
    
    //MARK:- Public properties
    var code = ""
    var textFieldText = ""
    var signUpUser: JFSignUpUser!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for enter code vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        for textField in digitTextFields {
            textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
        setupKeyboardObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        digitTextFields[0].becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:- User actions
    @IBAction func nextButtonTapped(_ sender: JFButton) {
        let vc = getChooseCategoriesVC()
        vc.signUpUser = self.signUpUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        invalidView.isHidden = true
    }
    
    @IBAction func resendCodeTapped(_ sender: JFButton) {
        resetAllTextFieldsToEmpty()
        resendTapped()
    }
    
    //MARK:- Helper methods
    func setupView() {
        setupKeyboardObservers()
        
        // Setting initial state of Buttons
        nextButton.isEnabled = false
    }
    
    func setupKeyboardObservers() {
        
        addKeyboardShowObserver { [weak self] height in
            self?.nextContainerBottom.constant = height
            if Devices.iPhone5AndSmallDevices {
                self?.labelTop.constant = 0
            }
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.nextContainerBottom.constant = 0
            
            if Devices.iPhone5AndSmallDevices {
                self?.labelTop.constant = 80
            }
        }
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        funct(textField)
        //invalidView.isHidden = true
        nextButton.isEnabled = isValid()
    }
    
    func funct(_ textField: UITextField) {
        if textField.text?.count == 1 {
            invalidView.isHidden = true
            for i in 0..<digitTextFields.count {
                if textField == digitTextFields[i] {
                    if i == digitTextFields.count - 1 {
                        activeButton()
                        textField.resignFirstResponder()
                        //view.endEditing(true)
                    } else {
                        digitTextFields[i+1].text = ""
                        digitTextFields[i+1].becomeFirstResponder()
                    }
                }
            }
        } else if ((textField.text?.count)! < 1) {
            if textField == digitTextFields[1] {
                digitTextFields[0].becomeFirstResponder()
            } else if textField == digitTextFields[2] {
                digitTextFields[1].becomeFirstResponder()
            } else if textField == digitTextFields[3] {
                digitTextFields[2].becomeFirstResponder()
            }
            textField.text = ""
        }
    }
    
    func isValid() -> Bool {
        for textFeild in digitTextFields {
            if textFeild.text == "" {
                return false
            }
        }
        return true
    }
    
    func getTextFieldText() {
        textFieldText = ""
        for textfield in digitTextFields {
            textFieldText.append(textfield.text!)
        }
    }
    
    func activeButton() {
        getTextFieldText()
        print("textfield text is: \(textFieldText)")
        
        if code != textFieldText {
            invalidView.isHidden = false
            errorLabel.text = "Invalid code."
            errorLabel.textColor = .red
            
            
            // Reset text field text to empty
            resetAllTextFieldsToEmpty()
            
        } else {
            invalidView.isHidden = true
        }
    }
    
    func resetAllTextFieldsToEmpty() {
        for aTextField in digitTextFields { aTextField.text = "" }
        
        digitTextFields[0].becomeFirstResponder()
    }
    
    func setupNavigation() {
        title = "VERIFICATION"
        addBackButton()
    }
}

extension JFEnterCodeViewController {
    func resendTapped() {
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.verifyingCode, animated: true)
        
        JFWSAPIManager.shared.sendTwillioVerificationCode(phoneNumber: self.signUpUser.phoneNumber) { [weak self] (success, errorMessage, code) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                strongSelf.code = code
                strongSelf.errorLabel.text = "Code sent."
                strongSelf.errorLabel.textColor = .black
                strongSelf.invalidView.isHidden = false
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.resendTapped()
                    }
                }
            }
        }
    }
}
