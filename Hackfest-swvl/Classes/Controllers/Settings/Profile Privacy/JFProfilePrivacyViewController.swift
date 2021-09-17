//
//  JFProfilePrivacyViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/2/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

enum ProfilePrivacy {
    case privacyPublic, privacyPrivate
    func getTitleText() -> String {
        switch self {
        case .privacyPublic:
            return "Public"
        case .privacyPrivate:
            return "Private"
        }
    }
    func getSubtitleText() -> String {
        switch self {
        case .privacyPublic:
            return "Anyone can see your profile, rate you, and request a rating from you. You can choose to accept anonymous ratings or not."
        case .privacyPrivate:
            return "Only people you approve can see your profile details, rate you, and request a rating from you. You can choose to accept anonymous rating or not."
        }
    }
}

typealias PrivacyTuple = (type: ProfilePrivacy, selected: Bool)

class JFProfilePrivacyViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profilePrivacyTableView: UITableView!

    //MARK:- Public properties
    var settingsPrivacy: SettingsData?
    var model: [PrivacyTuple] = [(.privacyPublic, true), (.privacyPrivate, false)]
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for profile privacy vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateModel()
        profilePrivacyTableView.register(identifiers: [JFProfilePrivacyCustomCell.self])
        
        profilePrivacyTableView.estimatedRowHeight = 150
        profilePrivacyTableView.rowHeight = UITableViewAutomaticDimension
        profilePrivacyTableView.dataSource = self
        profilePrivacyTableView.delegate = self
        profilePrivacyTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "PROFILE PRIVACY"
        addBackButton()
    }
    
    func updateModel() {
        model[0].selected = (settingsPrivacy?.isPublicProfile ?? false)
        model[1].selected = !(settingsPrivacy?.isPublicProfile ?? false)
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension JFProfilePrivacyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFProfilePrivacyCustomCell") as! JFProfilePrivacyCustomCell
        
        let privacyData = model[indexPath.row]
        cell.configureCell(data: privacyData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            settingsPrivacy?.isPublicProfile = true
            
        } else {
            settingsPrivacy?.isPublicProfile = false
        }
        updatePrivacyData()
    }
}

//MARK:- Network calls
extension JFProfilePrivacyViewController {
    func updatePrivacyData() {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.settingPrivacy, animated: true)
        
        let endPoint = JFUserEndpoint.settingsPrivacy(isPublicProfile: (settingsPrivacy?.isPublicProfile ?? false))
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<SettingsAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if response.success {
                strongSelf.updateModel()
                strongSelf.profilePrivacyTableView.reloadData()
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.updatePrivacyData()
                    }
                }
            }
        }
    }
}
