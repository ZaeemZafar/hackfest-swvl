//
//  JFChangePhoneEnterCodeViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/14/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFChangePhoneEnterCodeViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var enterCodeTextField: JFTextField!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var invalidView: UIView!
    @IBOutlet weak var incorrectLabelContainerViewBottom: NSLayoutConstraint!
    
    //MARK:- Public properties
    var code = ""
    var phoneNumber = ""
    var userInfo = ProfileInfo()
    
    //MARK:- Computed properties
    var hasError: Bool = false {
        didSet {
            enterCodeTextField.hasErrorMessage = hasError
            invalidView.isHidden = !hasError
        }
    }
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for change phone enter code vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        confirmationLabel.text = "Enter the confirmation code we sent to \(phoneNumber). If you didn’t get it, we can"
        enterCodeTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //setupNavigation()
        setupKeyboardObservers()
    }
    
    //MARK:- User actions
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        invalidView.isHidden = true
    }
    
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        resendTapped()
    }
    
    //MARK:- Helper methods
    func setupKeyboardObservers() {
        
        addKeyboardShowObserver { [weak self] height in
            self?.incorrectLabelContainerViewBottom.constant = height - 50
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.incorrectLabelContainerViewBottom.constant = 0
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
        changePhoneNumber()
    }
}

//MARK:- UITextFieldDelegate
extension JFChangePhoneEnterCodeViewController: UITextFieldDelegate {
    
    @IBAction func textChanged(_ sender: JFTextField) {
        if enterCodeTextField.text?.count == 4 {
            if enterCodeTextField.text == code {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                hasError = false
            } else {
                hasError = true
            }
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            hasError = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return textField.text!.count + (string.count - range.length) <= 4
    }
}

//MARK:- Network calls
extension JFChangePhoneEnterCodeViewController {
    func changePhoneNumber() {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.updatingPhoneNumber, animated: true)
        
        JFWSAPIManager.shared.updatePhoneNumber(phoneNumber: phoneNumber) {  [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.tabBarController?.view)!, title: "Saved", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                    
                    strongSelf.userInfo.phone = strongSelf.phoneNumber
                    
                    for vc in (strongSelf.navigationController?.viewControllers ?? []) {
                        if vc is JFEditProfileViewController {
                            _ = strongSelf.navigationController?.popToViewController(vc, animated: true)
                            break
                        }
                    }
                    
                })
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.changePhoneNumber()
                    }
                }
            }
        }
    }
    
    func resendTapped() {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.sendingCode, animated: true)
        
        JFWSAPIManager.shared.sendTwillioVerificationCode(phoneNumber: phoneNumber) { [weak self] (success, errorMessage, code) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.tabBarController?.view)!, title: "Code sent", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                    strongSelf.enterCodeTextField.text = ""
                    strongSelf.hasError = false
                })
                
                strongSelf.code = code
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.resendTapped()
                    }
                }
            }
        }
    }
}
