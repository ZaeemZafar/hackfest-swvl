//
//  JFSignUpFacebookViewController.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/5/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit
import AVFoundation
import AlamofireImage

class JFSignUpFacebookViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: JFTextField!
    @IBOutlet weak var lastNameTextField: JFTextField!
    @IBOutlet weak var emailTextField: JFTextField!
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var nextContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var nextButton: JFButton!
    
    //MARK:- Public properties
    lazy var signUpUser = JFSignUpUser()
    var showTermsOrPrivacy: TermsAndPrivacyWebRequest?
    var validator: Validator!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for signup facebook vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldsSettings()
        setupView()
        setupKeyboardObservers()
        scrollView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        profileContainerView.circleView()
        addProfileImageButton.circleView()
    }
    
    //MARK:- User actions
    @IBAction func textChanged(_ sender: JFTextField) {
        
        if JFValidator.shared.isValidEmail(text: emailTextField.text!)  {
            nextButton.isEnabled = true
            
        } else {
            nextButton.isEnabled = false
        }
    }
    
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
        emailTextField.text = signUpUser.email
        firstNameTextField.text = signUpUser.firstName
        lastNameTextField.text = signUpUser.lastName
        
        if let imageURL = signUpUser.imageURL {
            profileImageView.jf_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder")) { [weak self] in
                self?.signUpUser.imageFile = self?.profileImageView.image
            }
        }
        
        self.validator.validate()
    }
    
    func setupKeyboardObservers() {
        addKeyboardShowObserver { [weak self] height in
            self?.nextContainerViewBottom.constant = height
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.nextContainerViewBottom.constant = 0
        }
    }
    
    
    func textFieldsSettings() {
        validator = Validator(withView: view, scrollView: scrollView)
        validator.add(textField: firstNameTextField, rules: [.regex(.name), .maxLength(20)])
        validator.add(textField: lastNameTextField, rules: [.regex(.name), .maxLength(20)])
        
        validator.onValidationChange { [weak self] success in
            self?.nextButton.isEnabled = success
        }
    }
    
   
    func setupNavigation() {
        title = "ACCOUNT INFO"
        addBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "LoginWithEmail"?:
            let vc = segue.destination as! JFLoginViewController
            vc.prefilledEmailAddress = emailTextField.text ?? ""
            
        case "toTermsAndPrivacy"?:
            let vc = segue.destination as! JFTermsAndPrivacyViewController
            vc.currentWebRequest = showTermsOrPrivacy
            
        default: break
        }
    }
    
    func set(image: UIImage) {
        let resizedImage = image.resized(toWidth: JFConstants.uploadImageWidth)
        
        profileImageView.image = resizedImage
        profileImageView.contentMode = .scaleAspectFill
        signUpUser.imageFile = resizedImage
    }
}

//MARK:- Network calls
extension JFSignUpFacebookViewController {
    func nxtButtonTapped() {
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.signingUp, animated: true)
        
        JFWSAPIManager.shared.checkEmailExists(email: emailTextField.text ?? "") { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if (success) {
                
                if let firstName = strongSelf.firstNameTextField.text, let lastName = strongSelf.lastNameTextField.text, let email = strongSelf.emailTextField.text {
                    strongSelf.signUpUser.firstName = firstName
                    strongSelf.signUpUser.lastName = lastName
                    strongSelf.signUpUser.email = email
                }
                
                let vc = strongSelf.getVerificationVC()
                vc.signUpUser = strongSelf.signUpUser
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            } else if errorMessage == "Email already exists." {
                UIAlertController.showAlert(inViewController: strongSelf, title: "Hackfest-swvl", message: "Your Faceook accout already exist with Hackfest-swvl, Do you want to login with this account?", okButtonTitle: "Log In", cancelButtonTitle: "Cancel", completion: { success in
                    
                    if success {
                        strongSelf.performSegue(withIdentifier: "LoginWithEmail", sender: self)
                    } else {
                        strongSelf.navigationController?.popViewController(animated: true)
                    }
                })
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
