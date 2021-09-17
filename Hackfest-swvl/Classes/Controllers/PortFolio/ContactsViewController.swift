//
//  ContactsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/21/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var inviteContactsButton: JFButton!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    //MARK:- Public properties
    // TODO: JW - Remove this variable and use proper datasource for functional view binding
    var isDroarEmpty = false
    var allContacts = [JFContactInfo]()
    var existingContact = [JFProfile]()
    var invitedContact = [String]()
    var nonJFUser = [JFContactInfo]()
    var contactType: JFConnectContactsView = .contacts
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for contacts vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableViewForPagination()
        
        emptyViewLabel.text = "None of your contacts are on Hackfest-swvl yet! Would you like to invite them?"
        
//        if contactType == .facebook {
//            getFacebookContactsWithJFProfile()
//        }
        
        self.setNavTitle(title:"CONTACTS")
        self.inviteContactsButton.addSpacingWithTitle(title: "INVITE CONTACTS")
        
        self.setNavTitle(title: self.contactType.titleText)
        self.addBackButton()
        self.view.backgroundColor = UIColor.appBackGroundColor
        
        // TODO: JW - Use table view extension to register cells ~ Fixed
        contactsTableView.register(identifiers: [JFUserWithImageCustomCell.self, JFHeaderCustomCell.self, JFSettingsCustomCell.self])
        
        contactsTableView.estimatedRowHeight = 100
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contactsTableView.reloadData()
    }
    
    //MARK:- User actions
    @IBAction func inviteContacts() {
        navigateToInviteContactsVC()
    }
    
    //MARK:- Helper methods

    func getContactFromDevice(completion: CompletionBlockWithBool? = nil) {
        JFContacts.shared.fetchContactList { (result) in
            switch result {
            case .Success(response: let contacts):
                
                let validContacts = contacts.filter({$0.phoneNumbers.count > 0 || $0.emailAddresses.count > 0})
                
                // This includes all CNContacts which have either phone number OR email
                self.allContacts = validContacts.map({JFContactInfo(withContactInfo: $0)})
                
                print("Address book valid contcts \(validContacts)")
                print("Address book allContacts Mapped \(self.allContacts)")
                
                // Extract phone number of each contact
                var contactInfoArray = self.allContacts.filter({$0.phoneNumber.count >= 10}).map({$0.phoneNumber})
                contactInfoArray.append(contentsOf:(self.allContacts.filter({$0.email.isValidEmail}).map({$0.email})))
                
                contactInfoArray = contactInfoArray.filter({(JFSession.shared.myProfile?.phone.suffix(10) ?? "").contains($0.suffix(10)) == false})
                contactInfoArray = contactInfoArray.filter({(JFSession.shared.myProfile?.email ?? "") != $0})
                
                print("Contacts to be checked are \(contactInfoArray)")
                
                // Pass numbers to service and received should be translated in the phone of 2 Arrays
                if contactInfoArray.count > 0 {
                    
                    self.getContactsService(contacts: contactInfoArray, completion: { success in
                        if success {
                            
                            var exisitingContacts = self.existingContact.map({$0.phone})
                            exisitingContacts.append(contentsOf: self.existingContact.map({$0.email}))
                            exisitingContacts = exisitingContacts.filter({$0 != ""})
                            
                            let invitedContact = self.invitedContact
                            
                            
                            for aContactInfo in self.allContacts {
                                if exisitingContacts.contains(aContactInfo.email) || exisitingContacts.contains(aContactInfo.phoneNumber) {
                                    aContactInfo.status = ContactStatus.networkUser
                                }
                            }
                            
                            for aContactInfo in self.allContacts.filter({$0.status == .none}) {
                                if invitedContact.contains(aContactInfo.email) || invitedContact.contains(aContactInfo.phoneNumber) {
                                    aContactInfo.status = ContactStatus.invited
                                }
                            }
                            
                            //existingContact = self.existingContact.filter({$0.status == .networkUser}).map
                            print(self.allContacts)
                            self.contactsTableView.reloadData()
                            completion?(true)
                        }
                    })
                }
            case .Error(error: let error):
                // TODO: JW - Show error WRT to design
                print(error)
                completion?(false)
            }
        }
    }
    
    func navigateToInviteContactsVC() {
        let contactVC = getInviteContactVC()
        contactVC.inviteOrInvitedContacts = allContacts.filter({$0.status == ContactStatus.invited || $0.status == ContactStatus.none})
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView.isHidden = existingContact.count > 0 ? true : false
        return  section == 0 ? 1 : existingContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JFSettingsCustomCell") as! JFSettingsCustomCell
            cell.configureCellDataWithInvite(isFacebookInvite: false )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JFUserWithImageCustomCell") as! JFUserWithImageCustomCell
            tableView.separatorStyle = .singleLine
            let userData =  existingContact[indexPath.row]
            cell.configureCellWithData(cellData: userData, isContactsCell: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            navigateToInviteContactsVC()
            
        } else {
            let profileVC = self.getUserProfileVC()
            profileVC.userData = existingContact[indexPath.row]
            
            profileVC.userUpdated = { [weak self] userProfile in
                self?.existingContact.updateJFProfile(userProfile: userProfile)
            }
            
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        
        cell.headerLabel.text = "\(existingContact.count) Contacts on Hackfest-swvl"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0:50
    }
}

//MARK:- Network calls
extension ContactsViewController {
    func getFacebookService(facebookIDs: [String], completion:
        @escaping (_ success: Bool) -> ()) {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.gettingFacebookFriends, animated: true)
        
        let endPoint = JFUserEndpoint.facebookFriends(facebookIds: facebookIDs)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<ContactsAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success {
                guard let apiContactData = response.data?.contactsData else {return}
                strongSelf.existingContact =
                    apiContactData.existingUsers?.map({ (anExistingUser) -> JFProfile in
                        return JFProfile(profileData: anExistingUser)
                    }) ?? [JFProfile]()
                completion(true)
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                    }
                }
            }
        }
    }

    func getContactsService(contacts: [String], completion:
        @escaping (_ success: Bool) -> ()) {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.gettingContacts, animated: true)
        
        let endPoint = JFUserEndpoint.contacts(contacts: contacts)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<ContactsAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)

            if response.success {
                guard let apiContactData = response.data?.contactsData else {return}
                
                
                strongSelf.existingContact =
                    apiContactData.existingUsers?.map({ (anExistingUser) -> JFProfile in
                        return JFProfile(profileData: anExistingUser)
                    }) ?? [JFProfile]()
                
                let invitedEmails = apiContactData.invitedUsers?.filter({$0.email != nil}).map({$0.email ?? ""}) ?? [""]
                let invitedPhoneNumber = apiContactData.invitedUsers?.filter({$0.phoneNumber != nil}).map({$0.phoneNumber ?? ""}) ?? [""]
                
                strongSelf.invitedContact = invitedEmails + invitedPhoneNumber
                
                completion(true)
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                    }
                }
            }
        }
    }
}

// MARK: Table view pagination
extension ContactsViewController {
    func configureTableViewForPagination() {
        self.contactsTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            guard let strongSelf = self else { return }
            
            switch strongSelf.contactType {
            case .contacts:
                strongSelf.getContactFromDevice(completion: { Success in
                    strongSelf.contactsTableView.cr.endHeaderRefresh()
                })
            }
        }
    }
}
