//
//  JFSignUpViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/5/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import AVFoundation

class JFSignUpEmailViewController: JFViewController, KeyboardProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: JFTextField!
    @IBOutlet weak var lastNameTextField: JFTextField!
    @IBOutlet weak var emailTextField: JFTextField!
    @IBOutlet weak var createPasswordTextField: JFTextField!
    @IBOutlet weak var confirmPasswordTextField: JFTextField!
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var wholeContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var termsLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var nextButton: JFButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK:- Public properties
    lazy var signUpUser = JFSignUpUser()
    var showTermsOrPrivacy: TermsAndPrivacyWebRequest?
    var validator: Validator!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for signup email vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
        //setPrivacyAndPolicyAttributes()
    }
    
    override func viewDidLayoutSubviews() {
        profileContainerView.circleView()
        addProfileImageButton.circleView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:- User actions
    @IBAction func addProfileImageButtonTapped(_ sender: UIButton) {
        
        ImagePickerHelper.shared.showAlert(on: self) { [weak self] image in
            self?.set(image: image)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: JFButton) {
        nxtButtonTapped()
    }
    
    @IBAction func termsButtonTapped(_ sender: UIButton) {
        showTermsOrPrivacy = .termsAndConditions
        performSegue(withIdentifier: "toTermsAndPrivacy", sender: nil)
    }
    
    @IBAction func privacyButtonTapped(_ sender: UIButton) {
        showTermsOrPrivacy = .privacyPolicy
        performSegue(withIdentifier: "toTermsAndPrivacy", sender: nil)
    }
    
    //MARK:- Helper methods
    func setupView() {
        textFieldsSettings()
        setupKeyboardObservers()
        
        // Setting initial state of Buttons
        nextButton.isEnabled = false
    }
    func setupKeyboardObservers() {
        addKeyboardShowObserver(completion: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.scrollView.scrollToView(view: strongSelf.validator.getSelectedTextField(), animated: true)
        
        }) { [weak self] height in
            self?.nextContainerViewBottom.constant = height
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.nextContainerViewBottom.constant = 0
        }
    }
    
    func textFieldsSettings() {
        validator = Validator(withView: view)
        validator.add(textField: firstNameTextField, rules: [.regex(.name), .maxLength(20)])
        validator.add(textField: lastNameTextField, rules: [.regex(.name), .maxLength(20)])
        validator.add(textField: emailTextField, rules: [.regex(.email)])
        
        validator.add(textField: createPasswordTextField, rules: [.regex(.password)], showPasswordError: true) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                self?.termsLabelTopConstraint.constant = 30
                self?.show(errorMessage: "Password must be at least 8 characters long and include at least one letter, number, and special character.")
            }
        }
        validator.add(textField: confirmPasswordTextField, rules: [.matches(createPasswordTextField)], showPasswordError: true) { [weak self] success in
            if success {
                self?.hideErrorMessage()
            } else {
                self?.termsLabelTopConstraint.constant = 10
                self?.show(errorMessage: "Password does not match.")
            }
        }
        validator.onValidationChange { [weak self] success in
            self?.nextButton.isEnabled = success
        }
    }
    
    func show(errorMessage: String) {
        errorLabel.isHidden = false
        
        errorLabel.text = errorMessage
    }
    
    func hideErrorMessage() {
        errorLabel.isHidden = true
        termsLabelTopConstraint.constant = 0
    }
    
    func setupNavigation() {
        title = "ACCOUNT INFO"
        addBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! JFTermsAndPrivacyViewController
        vc.currentWebRequest = showTermsOrPrivacy
    }
    
    func set(image: UIImage) {
        let resizedImage = image.resized(toWidth: self.profileImageView.frame.width)
        
        profileImageView.image = resizedImage
        profileImageView.contentMode = .scaleAspectFill
        signUpUser.imageFile = resizedImage
    }
}

//MARK:- Network calls
extension JFSignUpEmailViewController {
    func nxtButtonTapped() {
        self.view.endEditing(true)
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.signingUp, animated: true)
        
        JFWSAPIManager.shared.checkEmailExists(email: emailTextField.text ?? "") { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if (success) {
                if let firstName = strongSelf.firstNameTextField.text, let lastName = strongSelf.lastNameTextField.text, let email = strongSelf.emailTextField.text, let password = strongSelf.createPasswordTextField.text {
                    strongSelf.signUpUser.firstName = firstName
                    strongSelf.signUpUser.lastName = lastName
                    strongSelf.signUpUser.email = email
                    strongSelf.signUpUser.password = password
                }
                
                let vc = strongSelf.getVerificationVC()
                vc.signUpUser = strongSelf.signUpUser
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            } else {
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
