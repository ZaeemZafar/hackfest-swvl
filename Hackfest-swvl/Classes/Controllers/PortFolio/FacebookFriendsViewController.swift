//
//  FacebookFriendsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/21/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class FacebookFriendsViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var fbFriendsTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    //MARK:- Public properties
    var isDroarEmpty = false
    
    var facebookFriendsCellTypes: [Int] = [CellType.following.rawValue, CellType.following.rawValue, CellType.requested.rawValue, CellType.requested.rawValue, CellType.follow.rawValue, CellType.follow.rawValue,CellType.follow.rawValue]
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for facebook friends vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavTitle(title: "Facebook Friends")
        self.addBackButton()
        self.view.backgroundColor = UIColor.appBackGroundColor
        fbFriendsTableView.register(UINib(nibName: "JFUserWithImageCustomCell", bundle: nil), forCellReuseIdentifier: "JFUserWithImageCustomCell")
        fbFriendsTableView.register(UINib(nibName: "JFHeaderCustomCell", bundle: nil), forCellReuseIdentifier: "JFHeaderCustomCell")
        
        fbFriendsTableView.register(UINib(nibName: "JFSettingsCustomCell", bundle: nil), forCellReuseIdentifier: "JFSettingsCustomCell")
        
        fbFriendsTableView.estimatedRowHeight = 100
        fbFriendsTableView.rowHeight = UITableViewAutomaticDimension
        fbFriendsTableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
        
        /// Add a observer to reload on the base of Test data
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("DroarNotification") , object: nil)
    }
    
    //MARK:- User actions
    @IBAction func inviteFacebookFriendsTapped() {
        
    }
    
    //MARK:- Helper methods
    // reloadData on the base of Droar
    @objc func reloadData(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        if value  {
            isDroarEmpty = false
            emptyView.isHidden = true
            fbFriendsTableView.reloadData()
        } else {
            isDroarEmpty = true
            emptyView.isHidden = false
            fbFriendsTableView.reloadData()
        }
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension FacebookFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JFSettingsCustomCell") as! JFSettingsCustomCell
            cell.configureCellDataWithInvite(isFacebookInvite: true)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JFUserWithImageCustomCell") as! JFUserWithImageCustomCell
            tableView.separatorStyle = .singleLine
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        } else {
            let profileVC = self.getUserProfileVC()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        
        cell.headerLabel.text = isDroarEmpty ? "0 Facebook Friends on Hackfest-swvl" : "7 Facebook Friends on Hackfest-swvl"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0:50
    }
}
