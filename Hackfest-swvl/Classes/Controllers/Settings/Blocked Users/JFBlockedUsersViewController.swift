//
//  JFBlockedUsersViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/7/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFBlockedUsersViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var blockedUsersTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    //MARK:- Public properties
    var usersData = [JFProfile]()
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for blocked user vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockedUsersTableView.register(identifiers: [JFUserWithImageCustomCell.self])
        
        blockedUsersTableView.estimatedRowHeight = 100
        blockedUsersTableView.rowHeight = UITableViewAutomaticDimension
        blockedUsersTableView.dataSource = self
        blockedUsersTableView.delegate = self
        blockedUsersTableView.tableFooterView = UIView()
        
        configureTableViewForPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getBlockedUsersData()
        setupNavigation()
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "BLOCKED USERS"
        addBackButton()
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension JFBlockedUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (usersData.count > 0) {
            emptyView.isHidden = true
            return usersData.count
        } else {
            emptyView.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFUserWithImageCustomCell") as! JFUserWithImageCustomCell
        if usersData.count > 0 {
            cell.configureCellWithBlockUserData(blockUser: usersData[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = getUserProfileVC()
        
        profileVC.userData = usersData[indexPath.row]
        profileVC.userData.blockedByMe = true
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}

//MARK:- Network calls
extension JFBlockedUsersViewController {
    func getBlockedUsersData() {
        
        let endPoint = JFUserEndpoint.blockList(page: 1, limit: 1000)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<BlockedUserAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            if response.success {
                
                guard let apiBlockedUsersData = response.data?.blockListData else {return}
                                
                let blockedUserProfile = apiBlockedUsersData.filter({$0.blockedUserRelation != nil}).map({$0.blockedUserRelation!})
                
                strongSelf.usersData = blockedUserProfile.map({JFProfile(profileData: $0)})
                strongSelf.blockedUsersTableView.reloadData()
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.getBlockedUsersData()
                    }
                }
            }
        }
    }
}

extension JFBlockedUsersViewController {
    func configureTableViewForPullToRefresh() {
        self.blockedUsersTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.blockedUsersTableView.cr.endHeaderRefresh()
            self?.getBlockedUsersData()
        }
    }
}
