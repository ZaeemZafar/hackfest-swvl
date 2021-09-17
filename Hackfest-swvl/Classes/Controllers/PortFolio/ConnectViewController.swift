//
//  ConnectFacebookViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/18/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

enum JFConnectContactsView {
    case contacts
    
    var titleText: String {
        switch self {
        case .contacts: return "Contacts"
        }
    }
    
    var headerLabelText: String {
        switch self {
        case .contacts: return "IMPORT CONTACTS"
        }
    }
    
    var subtitleText: String {
        switch self {
        case .contacts: return "See which of your contacts are already on Hackfest-swvl and choose who to follow."
        }
    }
    
    var placeholderText: String {
        switch self {
        case .contacts: return "Hackfest-swvl would like to access the contacts on your phone."
        }
    }
    
    var connected: Bool {
        switch self {
        case .contacts: return JFContacts.shared.hasBeenAuthorized
        }
    }
    
    var itemsCount: Int {
        switch self {
        case .contacts: return 0//JFContacts.shared.contactCount
        }
    }
}

class ConnectViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    //MARK:- Public properties
    var connectContactType: JFConnectContactsView = .contacts
    var viewControllerDimissed: ( (_ requestGranted: Bool) -> Void )?
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for connect vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTitle(title: connectContactType.titleText)
        view.backgroundColor = UIColor.appBackGroundColor
        addBackButton()
        
        setUpView()
    }
    
    //MARK:- User actions
    @IBAction func allowButtonTapped() {
        
        switch connectContactType {
        case .contacts:
            
            JFContacts.shared.contactAuthorizationStatus { (status) in
                switch status {
                case .notDetermined:
                    JFContacts.shared.requestContactAccess { [weak self] (accessResult) in
                        self?.dismiss(animated: true, completion: {
                            // fetching contact list to update Contacts count in shared object
                            JFContacts.shared.fetchContactList(completionHandler: { (fetchResult) in
                                
                                switch fetchResult {
                                case .Success(response: _):
                                    self?.viewControllerDimissed?(true)
                                    return
                                default:
                                    self?.viewControllerDimissed?(false)
                                }
                                
                            })
                        })
                    }
                    
                default:
                    UIAlertController.showAlertWithSettingsPrompt(title: "Contacts Permission", message: "You are not allowed to access system Contacts, please allow Hackfest-swvl to access Contacts from Settings", fromViewController: self)
                }
            }
        }
    }
    
    @IBAction func notAllowButtonTapped() {
        self.dismiss(animated: true, completion: {
            self.viewControllerDimissed?(false)
        })
    }
    
    //MARK:- Helper methods
    func setUpView() {
        headerLabel.text = connectContactType.headerLabelText
        subTitleLabel.text = connectContactType.subtitleText
        placeHolderLabel.text = connectContactType.placeholderText
    }
}
