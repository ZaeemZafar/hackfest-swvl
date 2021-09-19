//
//  JFPortFolioSubVC.swift
//  Hackfest-swvl
//
//  Created by zaktech on 7/24/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFPortFolioSubVC: UIViewController {

    
    //MARK:- IBOutlets
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    //MARK:- Private properties
    private let myNetworkArray = ["Expand Your Network", "Current Network"]
    
    //MARK:- Public properties
    var selectedTab: SelectedCategory = .following
    
    var metadata: APIMetadata?
    var userProfileDataSource: [JFProfile] = []
    var containerUpdatedUserProfile: ((JFProfile) -> ())?
    
    var allContacts = [JFContactInfo]()
    var existingContact = [JFProfile]()
    var existingFacebookFriends = [JFProfile]()
    var invitedContact = [String]()
    
    var expandMyNetworkButtonTapped: SimpleCompletionBlock?
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for portfolio sub vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableViewForPagination()
        
        portfolioTableView.register(identifiers: [JFUserWithImageCustomCell.self, JFHeaderCustomCell.self, JFSettingsCustomCell.self, EmptyCurrentNetworkCell.self])
        
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        
        portfolioTableView.estimatedRowHeight = 100
        portfolioTableView.rowHeight = UITableViewAutomaticDimension
        portfolioTableView.tableFooterView = UIView(frame: .zero)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        emptyView.isHidden = true
        portfolioTableView.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("DroarNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userProfileDataSource.count < 1 {
            loadDataForCategory(showLoader: JFServerManager.isConnectedToInternet)
        }

        if JFContacts.shared.hasBeenAuthorized {
            getContactFromDevice()
        }
        
        reloadTableView()
    }
    
    //MARK:- User actions
    @IBAction func expandYourNetworkButtonTapped(_ sender: JFButton) {
        expandMyNetworkButtonTapped?()
    }
    
    //MARK:- Helper methods
    
    func userContactCell(for row: Int) -> UITableViewCell {
        let cell = portfolioTableView.dequeueReusableCell(withIdentifier: "JFUserWithImageCustomCell") as! JFUserWithImageCustomCell
        portfolioTableView.separatorStyle = .singleLine
        
        if let userData = userProfileDataSource[safe: row] {
            cell.configureCellWithData(cellData: userData)
        }
        
        return cell
    }
    
    func emptyCell() -> UITableViewCell {
        let cell = portfolioTableView.dequeueReusableCell(withIdentifier: "EmptyCurrentNetworkCell") as! EmptyCurrentNetworkCell
        portfolioTableView.separatorStyle = .none
        cell.selectionStyle = .none
        return cell
    }
    
    func settingsCell(for row: Int) -> UITableViewCell {
        let cell = portfolioTableView.dequeueReusableCell(withIdentifier: "JFSettingsCustomCell") as! JFSettingsCustomCell
        var connectType = JFConnectContactsView.contacts
        
        cell.configureCellWithMyNetworkData(connectType: connectType)
        
        if connectType == .contacts {
            cell.countLabel.text = String(existingContact.count)
        } else {
            cell.countLabel.text = String(existingFacebookFriends.count)
        }
        
        return cell
    }
    
    @objc func reloadTableView() {
        
        if selectedTab == .following && userProfileDataSource.count < 1 {
            portfolioTableView.isHidden = true
            emptyView.isHidden = false
        } else {
            portfolioTableView.isHidden = false
            emptyView.isHidden = true
        }
        
        filterDataSourceModelArray()
        portfolioTableView.reloadData()
    }
    
    //MARK:- Helper methods for Contacts and Facebook
    func getContactFromDevice() {
        JFContacts.shared.fetchContactList { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .Success(response: let contacts):
                
                let validContacts = contacts.filter({$0.phoneNumbers.count > 0 || $0.emailAddresses.count > 0})
                
                // This includes all CNContacts which have either phone number OR email
                strongSelf.allContacts = validContacts.map({JFContactInfo(withContactInfo: $0)})
                
                print("Address book valid contcts \(validContacts)")
                print("Address book allContacts Mapped \(strongSelf.allContacts)")
                
                // Extract phone number of each contact
                var contactInfoArray = strongSelf.allContacts.filter({$0.phoneNumber.count >= 10}).map({$0.phoneNumber})
                contactInfoArray.append(contentsOf:(strongSelf.allContacts.filter({$0.email.isValidEmail}).map({$0.email})))
                contactInfoArray = contactInfoArray.filter({(JFSession.shared.myProfile?.phone.suffix(10) ?? "").contains($0.suffix(10)) == false})
                contactInfoArray = contactInfoArray.filter({(JFSession.shared.myProfile?.email ?? "") != $0})
                
                print("Contacts to be checked are \(contactInfoArray)")
                
                // Pass numbers to service and received should be translated in the phone of 2 Arrays
                if contactInfoArray.count > 0 {
                    
                    strongSelf.getContactsService(contacts: contactInfoArray, completion: { success in
                        if success {
                            
                            var exisitingContacts = strongSelf.existingContact.map({$0.phone})
                            exisitingContacts.append(contentsOf: strongSelf.existingContact.map({$0.email}))
                            exisitingContacts = exisitingContacts.filter({$0 != ""})
                            
                            let invitedContact = strongSelf.invitedContact
                            
                            
                            for aContactInfo in strongSelf.allContacts {
                                if exisitingContacts.contains(aContactInfo.email) || exisitingContacts.contains(aContactInfo.phoneNumber) {
                                    aContactInfo.status = ContactStatus.networkUser
                                }
                            }
                            
                            for aContactInfo in strongSelf.allContacts.filter({$0.status == .none}) {
                                if invitedContact.contains(aContactInfo.email) || invitedContact.contains(aContactInfo.phoneNumber) {
                                    aContactInfo.status = ContactStatus.invited
                                }
                            }
                            
                            //existingContact = self.existingContact.filter({$0.status == .networkUser}).map
                            print(strongSelf.allContacts)
                            strongSelf.portfolioTableView.reloadData()
                        }
                    })
                }
                
            case .Error(error: let error):
                // TODO: JW - Show error WRT to design
                print(error)
            }
        }
    }

}

//MARK:- UITableViewDataSource
extension JFPortFolioSubVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedTab == .myNetworks ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .following, .discover:
            return userProfileDataSource.count
        
        case .myNetworks:
            if section == 0 {
                return JFConstants.facebookDisabled ? 1 : 2
            } else {
                return userProfileDataSource.count == 0 ? 1 : userProfileDataSource.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 || selectedTab == .discover || selectedTab == .following {
            return userProfileDataSource.count == 0 ? selectedTab == .discover ? userContactCell(for: indexPath.row) : emptyCell() : userContactCell(for: indexPath.row)
        } else {
            return settingsCell(for: indexPath.row)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedTab == .myNetworks && indexPath.section == 0  {
           
            var connectType = JFConnectContactsView.contacts
            
            if connectType.connected {
                let vc = getContactsVC()
                vc.contactType = connectType
                
                vc.existingContact = self.existingContact
                vc.allContacts = self.allContacts
                
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let connectVC = self.getConnectVC()
                connectVC.connectContactType = connectType
                
                connectVC.viewControllerDimissed = { [weak self] granted in
                    self?.reloadTableView()
                    
                    if granted {
                        let vC = self?.getContactsVC()
                        vC?.contactType = connectType
                        vC?.existingContact = (self?.existingContact)!
                        vC?.allContacts = (self?.allContacts)!
                        self?.navigationController?.pushViewController(vC!, animated: true)
                        
                    } else {
                        // Do nothing for now
                    }
                    
                }
                
                let navigationController = UINavigationController(rootViewController: connectVC)
                self.navigationController?.present(navigationController, animated: true, completion: nil)
            }
        } else {
            guard let cellData = userProfileDataSource[safe: indexPath.row] else {return}
            let profileVC = getUserProfileVC()
            
            profileVC.userData = cellData
            
            profileVC.userUpdated = { [weak self] userProfile in
                self?.containerUpdatedUserProfile?(userProfile)
            }
            
            self.navigationController?.pushViewController(profileVC, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        cell.headerLabel.text = myNetworkArray[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return selectedTab == .myNetworks ? 50 : 0
    }
    
}

//MARK:- UITableViewDelegate
extension JFPortFolioSubVC: UITableViewDelegate {
    func updateProfile(userProfile: JFProfile) {
        self.userProfileDataSource.setJFProfile(userProfile: userProfile)
        self.filterDataSourceModelArray()
    }
}

extension JFPortFolioSubVC {
    func loadDataForCategory(showLoader: Bool = false, completion: CompletionBlockWithBool? = nil) {
        let loadingText = selectedTab.getLoadingText()
        let currentPage = metadata?.page ?? 1
        let endPoint: JFUserEndpoint = selectedTab.getUserEndPoint(currentPage: currentPage)
        
        if showLoader {
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: loadingText, animated: true)
        }
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<UsersNetworkAPIBase>) in
            completion?(response.success)
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success {
                guard let apiNetworkData = response.data?.networkData else { return }
                guard let apiMetaData = response.data?.metadata else { return }
                
                strongSelf.metadata = apiMetaData
                strongSelf.userProfileDataSource.append(contentsOf: apiNetworkData.map({JFProfile(profileData: $0)}))

                self?.reloadTableView()
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.loadDataForCategory(showLoader: showLoader)
                    }
                }
            }
        }
    }
    
    func filterDataSourceModelArray() {
//        switch selectedTab {
//        case .discover:
//            break
//            
//        case .myNetworks:
//            userProfileDataSource = userProfileDataSource.filter({$0.followingState == .following || $0.followedByState == .following})
//            
//        case .following:
//            userProfileDataSource = userProfileDataSource.filter({$0.followingState == .following})
//        }
    }

}

//MARK:- Network calls
extension JFPortFolioSubVC {
    func getFacebookService(facebookIDs: [String], completion:
        @escaping (_ success: Bool) -> ()) {
        
        let endPoint = JFUserEndpoint.facebookFriends(facebookIds: facebookIDs)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<ContactsAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            if response.success {
                guard let apiContactData = response.data?.contactsData else {return}
                strongSelf.existingFacebookFriends =
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
        
        let endPoint = JFUserEndpoint.contacts(contacts: contacts)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<ContactsAPIBase>) in
            
            guard let strongSelf = self else { return }
            
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

// MARK: UITableView Pagination
extension JFPortFolioSubVC {
    func configureTableViewForPagination() {
        self.portfolioTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.metadata?.resetMetadata()
            strongSelf.portfolioTableView.cr.resetNoMore()
            strongSelf.userProfileDataSource.removeAll()
            
            strongSelf.loadDataForCategory() { _ in
                strongSelf.portfolioTableView.cr.endHeaderRefresh()
            }
        }
        
        self.portfolioTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let strongSelf = self else {return}
            guard let currentPage = strongSelf.metadata?.page else {return}
            guard let totalPages = strongSelf.metadata?.totalPages else {return}
            
            if currentPage < totalPages {
                strongSelf.metadata!.page = strongSelf.metadata!.page! + 1
                
                strongSelf.loadDataForCategory() { success in
                    self?.portfolioTableView.cr.endLoadingMore()
                    
                    if success && strongSelf.metadata?.page == strongSelf.metadata?.totalPages {
                        strongSelf.portfolioTableView.cr.noticeNoMoreData()
                    }
                }
            } else {
                /// Reset no more data
                strongSelf.portfolioTableView.cr.noticeNoMoreData()
            }
        }
    }
}
