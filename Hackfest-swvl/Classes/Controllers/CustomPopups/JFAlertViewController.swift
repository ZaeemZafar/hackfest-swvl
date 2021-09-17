//
//  JFAlertViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/9/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit
import CoreLocation

typealias SimpleCompletionBlock = () -> ()
typealias CompletionBlockWithBool = (Bool) -> ()
typealias CompletionBlockWithLocationCoordinate = (_ success: Bool, _ location: CLLocationCoordinate2D?) -> ()

enum AlertType {
    case forgotPassword
    case changePassword
    case changeEmail(email: String)
    case requestRating(userName: String)
    case requestRatingTimeError(userName: String)
    case rateUser(userName: String)
    case acceptRatings
    case connectFacebook
    case networkError
    case inactiveUser
    case defaultSystemAlert(message: String)
}

class JFAlertViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneButton: JFButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var containerViewbottom: NSLayoutConstraint!
    @IBOutlet weak var titleImageTopConstraint: NSLayoutConstraint!
    
    //MARK:- Public properties
    var titleImg: UIImage!
    var titleLbl: String!
    var descriptionLbl: NSAttributedString!
    var doneButtonTitle: String!
    var completion: CompletionBlockWithBool?
    var showCrossButton: Bool!
    var selectedAlertType: AlertType = .connectFacebook
    
    //MARK:- Computed properties
    var _selectedAlertType: AlertType = .connectFacebook {
        didSet {
            let formattedString = NSMutableAttributedString()
            
            switch selectedAlertType {
            case .forgotPassword:
                formattedString
                    .normal(NSLocalizedString("Please check your email, we've sent you a link to reset your password.", comment: ""))
                
                setAlert(image: #imageLiteral(resourceName: "email_success_icon_yellow"), title: "Success!", desc: formattedString, btnText: JFLocalizableConstants.OKAYTitle, btnCross: false)
                
            case .changePassword:
                formattedString
                    .normal("Changes were made to your password. Do you want to save these changes?")
                
                setAlert(image: nil, title: "Save Changes", desc: formattedString, btnText: "YES, SAVE CHANGES", btnCross: true)
            case .changeEmail(let email):
                formattedString
                    .normal("Follow the link in the email we sent to \(email) to confirm your email address and help secure your account.")
                
                setAlert(image: nil, title: "Check Your Email", desc: formattedString, btnText: "OKAY", btnCross: false)
            case .requestRating(let userName):
                formattedString
                    .normal("Request a rating from ")
                    .bold(userName)
                    .normal(" ?")
                
                setAlert(image: #imageLiteral(resourceName: "portfolio_icon_yellow"), title: "Request Rating", desc: formattedString, btnText: "YES", btnCross: true)
            case .requestRatingTimeError(let userName):
                formattedString
                    .normal("You need to wait 60 minutes before requesting ")
                    .bold(userName)
                    .normal(" again.")
                setAlert(image: nil, title: "Cannot Request Again Yet", desc: formattedString, btnText: "OKAY", btnCross: false)

            case .rateUser(let userName):
                formattedString
                    .normal("You need to wait 60 minutes before rating ")
                    .bold(userName)
                    .normal(" again.")
                
                setAlert(image: nil, title: "Cannot Rate Again Yet", desc: formattedString, btnText: "OKAY", btnCross: false)
            case .acceptRatings:
                formattedString
                    .normal("Are you sure you want to stop receiving ratings from everyone?")
                
                setAlert(image: nil, title: "Stop Accepting Ratings", desc: formattedString, btnText: "YES, CONTINUE", btnCross: true)
            case .connectFacebook:
                formattedString
                    .normal("Are you sure you want to disconnect from Facebook?")
                
                setAlert(image: nil, title: "Disconnect Facebook", desc: formattedString, btnText: "YES, DISCONNECT", btnCross: true)
            case .networkError:
                formattedString
                    .normal("Check your network connection \nto use Hackfest-swvl.")
                setAlert(image: nil, title: "No Network Connection", desc: formattedString, btnText: "RETRY", btnCross: true)
            case .inactiveUser:
                formattedString
                    .normal("This user no longer exists.")
                setAlert(image: nil, title: "Inactive User", desc: formattedString, btnText: "OKAY", btnCross: false)
            case .defaultSystemAlert(let message):
                
                break
            }
        }
    }
    
    // MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for alert :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        _selectedAlertType = self.selectedAlertType
        
        if self.titleImage.image == nil  {
            titleImageTopConstraint.constant = -20
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.containerViewbottom.constant = 8
            self.view.layoutSubviews()
        }
    }
    
    //MARK:- Actions
    @IBAction func doneButtonTapped(_ sender: JFButton) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.containerViewbottom.constant = -400
            self.view.layoutSubviews()
            
        }) { finished in
            
            if finished {
                self.dismiss(animated: true, completion: nil)
                self.completion?(true)
            }
        }
    }
    
    @IBAction func crossButtonPressed(_ sender: UIButton) {
        completion?(false)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper
    func setAlert(image: UIImage?, title: String, desc: NSAttributedString, btnText: String, btnCross: Bool) {
        //(image == nil) ? (titleTopConstraint.constant = -20) : (titleImage.image = image)
        titleImage.image = image
        titleLabel.text = title
        descriptionLabel.attributedText = desc
        doneButton.addSpacingWithTitle(spacing: 2.0, title: btnText)
        btnCross ? (crossButton.isHidden = false) : (crossButton.isHidden = true)
    }
    
    func setupUIConstraints() {
        containerViewbottom.constant = -400
    }
    
    class func alertController(with alertType: AlertType, completion: CompletionBlockWithBool?) -> JFAlertViewController {
        let storyboard = UIStoryboard(name: "CustomViews", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "JFAlertViewController") as! JFAlertViewController
        
        vc.completion = completion
        vc.selectedAlertType = alertType
        
        return vc
    }
    
    @discardableResult
    class func presentAlertController(with alertType: AlertType, fromViewController presentingVC: UIViewController?, completion: CompletionBlockWithBool?) -> JFAlertViewController? {
        guard let vc = presentingVC else {return nil}
        
        switch alertType {
        case .defaultSystemAlert(let message):
            UIAlertController.showOkayAlert(inViewController: vc, message: message)
            return nil
            
        default:
            let alertVC = JFAlertViewController.alertController(with: alertType, completion: completion)
            
            vc.present(alertVC, animated: true, completion: nil)
            return alertVC
        }
    }
    
    func presentVC(from presentingVC: UIViewController?) {
        presentingVC?.present(self, animated: true, completion: nil)
    }
}
