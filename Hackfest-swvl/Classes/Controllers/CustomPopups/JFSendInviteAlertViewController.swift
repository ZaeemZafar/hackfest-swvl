//
//  JFSendInviteAlertViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/22/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import MessageUI

typealias InviteCompletion = (InviteMedium?) -> Void

class JFSendInviteAlertViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var smsView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    //MARK:- Public properties
    var jfContactInfo: JFContactInfo?
    var completion: ((InviteMedium?) -> Void)?
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for alert 2 :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        self.cancelButton.addButtonSpacingWithTitle(spacing: 2.0, title: (cancelButton.titleLabel?.text)!)
    }
    
    //MARK:- User actions
    @IBAction func smsButtonTapped(_ sender: UIButton) {
        print("Sms Tapped")
        inviteService(inviteVia: .viaSMS)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        print("Email Tapped")
        inviteService(inviteVia: .viaEmail)
    }
    
    @IBAction func cancelTapped() {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:- Helper methods
    func setupView() {
        guard let contactInfo = jfContactInfo else {return}
        
        switch contactInfo.canInvite {
        case .viaSMS:
            emailView.isHidden = true
        case .viaEmail:
            smsView.isHidden = true
        case .Both:
            smsView.isHidden = false
            emailView.isHidden = false
        }
    }
    
    func successfullyInvited() {
        completion?(nil)
        dismiss(animated: false, completion: nil)
    }
    
    // TODO: this should be deprecated as 'jfContactInfo' is not optional AND initializer don't really initialize it anymore
    class func inviteController(completion: InviteCompletion?) -> JFSendInviteAlertViewController {
        let storyboard = UIStoryboard(name: "CustomViews", bundle: nil)
        let vC = storyboard.instantiateViewController(withIdentifier: "JFSendInviteAlertViewController") as! JFSendInviteAlertViewController
        
        vC.modalPresentationStyle = .overCurrentContext
        vC.completion = completion
        return vC
    }
    
    @discardableResult
    class func presentInviteController(with contactInfo: JFContactInfo? = nil, fromViewController presentingVC: UIViewController?, completion: InviteCompletion?) -> JFSendInviteAlertViewController? {
        guard let vc = presentingVC else {return nil}
        
        let inviteVC = JFSendInviteAlertViewController.inviteController(completion: completion)
        inviteVC.jfContactInfo = contactInfo
        vc.present(inviteVC, animated: true, completion: nil)
        return inviteVC
    }
}

//MARK:- Network calls
extension JFSendInviteAlertViewController {
    func inviteService(inviteVia: InviteMedium) {
        guard let contactInfo = jfContactInfo else {
            self.dismiss(animated: true, completion: nil)
            completion?(inviteVia)
            return
        }
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.view, title: JFLoadingTitles.invitingUser, animated: true)
        
        let endPoint = inviteVia == .viaSMS ? JFUserEndpoint.inviteViaSMS(phoneNumber: contactInfo.phoneNumber) : JFUserEndpoint.inviteViaEmail(email: contactInfo.email)
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.view, animated: true)
            
            if response.success { // successfully invited
                
                MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.view), title: "Invite sent", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    strongSelf.successfullyInvited()
                })
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf) { success in
                    if success {
                        strongSelf.inviteService(inviteVia: inviteVia)
                    }
                }
            }
        }
    }
}
