//
//  JFSignupViewController.swift
//  Hackfest-swvl
//
//  Created by Umair on 16/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
/****
enum JFSignupStage: Int {
    case info = 1
    case smsVerification
    case settings
    case permissions
}

enum JFSignupStep: Int {
    case accountInfo = 1
    case phoneNumber
    case verificationCode
    case categories
    case privacySettings
    case notificationAccess
    case locationAccess
}
/**
class JFSignupViewController: UIViewController {

    // MARK: -
    
    @IBOutlet weak var progressView: JFProgressView!
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var accountInfoVC: QVSignupCompanyInfoViewController!
    fileprivate var phoneVC: QVSignupPhoneViewController!
    fileprivate var smsVC: QVSignupSMSViewController!
    fileprivate var categoriesVC: QVSignupPersonalInfoViewController!
    fileprivate var privacyVC: QVSignupPasswordViewController!
    fileprivate var notificationVC: QVSignupPINViewController!
    fileprivate var locationVC: QVSignupConfirmationViewController!
    
    fileprivate var currentStage = JFSignupStage.info
    fileprivate var currentStep = JFSignupStep.accountInfo
    
    fileprivate var currentController: UIViewController?
    
    // MARK: -
    // MARK: Init & dealloc methods
    
    required init(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)!
    }
    
    deinit {
        
    }
    
    // MARK: -
    // MARK: UIViewController methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setup()
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: -
    // MARK: User Action methods
    /**
    func backBarButtonItemTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        switch currentStage {
            
        case .info:
            switch currentStep {
            case .companyInfo:
                
                _ = self.navigationController?.popViewController(animated: true)
                break
                
            case .phone:
                // Move back to previous step
                
                companyVC.userEmail = userInfo.email
                animate(fromViewController: currentController, toViewController: companyVC, slideFromRight: false, animateProgress: true, progressView: stage1ProgressView) {
                    self.currentStep = .companyInfo
                    self.updateStageElements()
                    self.updateNavigationTitle()
                }
                break
                
            case .sms:
                // Move back to previous step
                
                phoneVC.phoneNumber = userInfo.phoneNumber
                
                animate(fromViewController: currentController, toViewController: phoneVC, slideFromRight: false, animateProgress: true, progressView: stage1ProgressView) {
                    self.currentStep = .phone
                    self.updateStageElements()
                    self.updateNavigationTitle()
                }
                
                break
                
            default:
                
                break
            }
            
            break
            
        case .personal:
            // Move back to previous stage
            // Move back to previous step
            animate(fromViewController: currentController, toViewController: smsVC, slideFromRight: false, animateProgress: true, progressView: stage1ProgressView) {
                self.currentStage = .info
                self.currentStep = .sms
                self.updateStageElements()
                self.updateNavigationTitle()
            }
            
            break
            
        case .security:
            //            // Move back to previous stage
            switch currentStep {
            case .password:
                // Move back to previous step
                currentStage = .personal
                currentStep = .personalInfo // This is the 1st step of personal
                
                personalVC.firstName = userInfo.firstName
                personalVC.lastName = userInfo.lastName
                personalVC.nickName = userInfo.nickName
                
                animate(fromViewController: currentController, toViewController: personalVC, slideFromRight: false, animateProgress: true, progressView: stage2ProgressView) {
                    self.updateStageElements()
                    self.updateNavigationTitle()
                }
                break
                
            case .pin:
                // Move back to previous step
                passwordVC.password = userInfo.password
                
                currentStage = .personal
                currentStep = .password // This is the 1st step of personal
                
                animate(fromViewController: currentController, toViewController: passwordVC, slideFromRight: false, animateProgress: true, progressView: stage2ProgressView) {
                    self.updateStageElements()
                    self.updateNavigationTitle()
                }
                break
            default:
                break
            }
            break
            
        case .verify:
            // Move back to previous stage
            
            currentStage = .security
            currentStep = .password // This is the 1st step of security
            
            passwordVC.password = userInfo.password
            
            animate(fromViewController: currentController, toViewController: passwordVC, slideFromRight: false, animateProgress: true, progressView: stage3ProgressView) {
                self.updateStageElements()
                self.updateNavigationTitle()
            }
            
            break
        }
        
    }
    **/
    // MARK: -
    // MARK: Public methods
    
    func accountInfoComplete(firstName: String, lastName: String, email: String, password: String) {
//        userInfo.email = email
        
        currentStage = .smsVerification
        currentStep = .phoneNumber
        
//        phoneVC.phoneNumber = userInfo.phoneNumber
        
        animate(fromViewController: <#T##UIViewController?#>, toViewController: <#T##UIViewController#>, slideFromRight: true, animateProgress: true) {
            self.updateNavigationTitle()
        }
        animate(fromViewController: companyVC, toViewController: phoneVC, slideFromRight: true, animateProgress: false, progressView: nil) {
            self.updateNavigationTitle()
        }
    }
    
    func phoneInfoComplete(phoneNumber: String, verificationCode: String) {
        userInfo.phoneNumber = phoneNumber
        
        currentStep = .sms
        
        smsVC.phoneNumber = userInfo.phoneNumber
        smsVC.verificationCode = verificationCode
        
        animate(fromViewController: phoneVC, toViewController: smsVC, slideFromRight: true, animateProgress: false, progressView: nil) {
            self.updateNavigationTitle()
        }
    }
    
    func smsVerificationComplete() {
        currentStage = .personal
        currentStep = .personalInfo
        
        personalVC.firstName = userInfo.firstName
        personalVC.lastName = userInfo.lastName
        personalVC.nickName = userInfo.nickName
        
        animate(fromViewController: smsVC, toViewController: personalVC, slideFromRight: true, animateProgress: true, progressView: stage1ProgressView) {
            self.updateStageElements()
            self.updateNavigationTitle()
        }
    }
    
    func personalInfoComplete(firstName: String, lastName: String, nickName: String) {
        userInfo.firstName = firstName
        userInfo.lastName = lastName
        userInfo.nickName = nickName
        
        currentStage = .security
        currentStep = .password
        
        passwordVC.password = userInfo.password
        
        animate(fromViewController: personalVC, toViewController: passwordVC, slideFromRight: true, animateProgress: true, progressView: stage2ProgressView) {
            self.updateStageElements()
            self.updateNavigationTitle()
        }
    }
    
    func passwordCreationComplete(password: String) {
        userInfo.password = password
        
        currentStep = .pin
        
        pinVC.pinCode = userInfo.pinCode
        pinVC.addTouchID = userInfo.hasTouchID
        
        animate(fromViewController: passwordVC, toViewController: pinVC, slideFromRight: true, animateProgress: false, progressView: nil) {
            self.updateNavigationTitle()
        }
    }
    
    func pinCreationComplete(pinCode: String) {
        userInfo.pinCode = pinCode
        
        currentStage = .verify
        currentStep = .confirmation
        
        confirmationVC.userInfo = userInfo
        
        animate(fromViewController: pinVC, toViewController: confirmationVC, slideFromRight: true, animateProgress: true, progressView: stage3ProgressView) {
            self.navigationItem.leftBarButtonItem = nil
            self.updateStageElements()
            self.updateNavigationTitle()
        }
    }
    
    func someThingWentWrongTriggred() {
        // Move back start
        currentStage = .info
        currentStep = .companyInfo // This is the 1st step of info
        
        companyVC.userEmail = userInfo.email
        
        animate(fromViewController: currentController, toViewController: companyVC, slideFromRight: false, animateProgress: false, progressView: nil) {
            self.navigationItem.leftBarButtonItem = self.backBarButtonItem
            self.updateStageElements()
            self.updateNavigationTitle()
        }
    }
    
    func clientAccountSetupComplete() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func employeeAccountSetupComplete() {
        userInfo.saveSignupUser()
    }
    
    // MARK: -
    // MARK: Private methods
    
    fileprivate func setupNavigationBar() {
        updateNavigationTitle()
    }
    
    fileprivate func setup() {
        updateStageElements()
    }
    
    fileprivate func setupViewControllers() {
        companyVC = UIStoryboard.signup.instantiateViewController(withIdentifier: "QVSignupCompanyInfoViewController") as! QVSignupCompanyInfoViewController
        phoneVC = UIStoryboard.signup.instantiateViewController(withIdentifier: "QVSignupPhoneViewController") as! QVSignupPhoneViewController
        smsVC = UIStoryboard.signup.instantiateViewController(withIdentifier: "QVSignupSMSViewController") as! QVSignupSMSViewController
        personalVC = UIStoryboard.signup.instantiateViewController(withIdentifier: "QVSignupPersonalInfoViewController") as! QVSignupPersonalInfoViewController
        passwordVC = UIStoryboard.signup.instantiateViewController(withIdentifier: "QVSignupPasswordViewController") as! QVSignupPasswordViewController
        pinVC = UIStoryboard.signup.instantiateViewController(withIdentifier: "QVSignupPINViewController") as! QVSignupPINViewController
        confirmationVC = UIStoryboard.signup.instantiateViewController(withIdentifier: "QVSignupConfirmationViewController") as! QVSignupConfirmationViewController
        
        companyVC.signupVC = self
        phoneVC.signupVC = self
        smsVC.signupVC = self
        personalVC.signupVC = self
        passwordVC.signupVC = self
        pinVC.signupVC = self
        confirmationVC.signupVC = self
    }
    
    fileprivate func updateNavigationTitle() {
        
        switch currentStep {
            
        case .accountInfo:
            self.title = NSLocalizedString("ACCOUNT INFO", comment: "")
            break
            
        case .phoneNumber:
            self.title = NSLocalizedString("VERIFICATION", comment: "")
            break
            
        case .verificationCode:
            self.title = NSLocalizedString("VERIFICATION", comment: "")
            break
            
        case .categories:
            self.title = NSLocalizedString("CATEGORIES", comment: "")
            break
            
        case .privacySettings:
            self.title = NSLocalizedString("PRIVACY SETTINGS", comment: "")
            break
            
        case .notificationAccess:
            self.title = NSLocalizedString("NOTIFICATIONS", comment: "")
            break
            
        case .locationAccess:
            self.title = NSLocalizedString("LOCATION ACCESS", comment: "")
            break
            
        default:
            break
        }
    }

    fileprivate func animate(fromViewController: UIViewController?,
                             toViewController: UIViewController,
                             slideFromRight: Bool = true,
                             animateProgress: Bool = false,
                             progressValue: Int = 0,
                             completion: (() -> Swift.Void)? = nil) {
        let finalRect = containerView.bounds
        
        if fromViewController == nil {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            
            addChildViewController(toViewController)
            toViewController.view.frame = finalRect
            containerView.addSubview(toViewController.view)
            containerView.addFourPinContraintsToSubview(subV: toViewController.view, topMargin: 0, leadingMargin: 0, trailingMargin: 0, bottomMargin: 0)
            toViewController.didMove(toParentViewController: self)
            currentController = toViewController
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            
        } else if (fromViewController != toViewController) {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            
            fromViewController?.willMove(toParentViewController: nil)
            addChildViewController(toViewController)
            
            if slideFromRight {
                toViewController.view.frame = CGRect(x: finalRect.size.width, y: 0, width: finalRect.size.width, height: finalRect.size.height)
                
            } else {
                toViewController.view.frame = CGRect(x: -finalRect.size.width, y: 0, width: finalRect.size.width, height: finalRect.size.height)
            }
            
            containerView.addSubview(toViewController.view)
            containerView.addFourPinContraintsToSubview(subV: toViewController.view, topMargin: 0, leadingMargin: 0, trailingMargin: 0, bottomMargin: 0)
            
            if animateProgress == false {
                progressView.progressValue = progressValue
            }
            
            transition(from: fromViewController!,
                       to: toViewController,
                       duration: 0.3,
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {
                        
                        toViewController.view.frame = finalRect
                        
                        if animateProgress == true {
                            self.progressView.progressValue = progressValue
                        }
                        
            }, completion: { (Bool) in
                fromViewController?.view.removeFromSuperview()
                fromViewController?.removeFromParentViewController()
                
                toViewController.didMove(toParentViewController: self)
                self.currentController = toViewController
                
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                
                if completion != nil {
                    completion!()
                }
            })
        }
    }
    **/
}
***/
