//
//  JFSettingsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/1/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import SwiftLocation

enum JFSettingSections {
    case account, ratings, notifications, about, logout
    func getSectionTitle() -> String {
        switch self {
        case .account:
            return "Account"
        case .ratings:
            return "Ratings"
        case .notifications:
            return "Notifications"
        default:
            return ""
        }
    }
}

enum JFSettingRows {
    case profilePrivacy, currentLocation, blockedUsers, ratings, notifications, about, terms, privacy, faq, logout, delete
    func getRowText() -> String {
        switch self {
        case .profilePrivacy:
            return "Profile Privacy"
        case .currentLocation:
            return "Current Location"
        case .blockedUsers:
                return "Blocked Users"
        case .ratings:
            return "Ratings"
        case .notifications:
            return "Allow Notifications"
        case .about:
            return "About Hackfest-swvl"
        case .terms:
            return "Terms & Conditions"
        case .privacy:
                return "Privacy Policy"
        case .faq:
            return "FAQ + Help"
        case .logout:
            return "Log Out"
        case .delete:
            return "Delete Account"
        }
    }
    func showArrow() -> Bool {
        switch self {
        case .blockedUsers:
            return true
        default:
            return false
        }
    }
    func showSwitch() -> Bool {
        switch self {
        case .currentLocation, .notifications:
            return true
        default:
            return false
        }
    }
    func isOrange() -> Bool {
        switch self {
        case .logout, .delete:
            return true
        default:
            return false
        }
    }
    func getImage() -> UIImage? {
        return nil
    }
}

class JFSettingsViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var settingsTableView: UITableView!
    
    //MARK:- Private properties
    private weak var actionToEnable : UIAlertAction?
    
    //MARK:- Public properties
    var showTermsOrPrivacyOrAbout: TermsAndPrivacyWebRequest?
    var settingsData: SettingsData?
    var facebookWorkInProgress = false
    var locationManager: CLLocationManager!
    let sections: [JFSettingSections] = [ .account, .ratings, .notifications, .about, .logout ]
    var rows: [JFSettingSections: [JFSettingRows]] = [:]
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for settings vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadRowsData(showFbLink: false)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        settingsTableView.register(identifiers:
            [
                JFMultiLabelCustomCell.self,
                JFSettingsCustomCell.self,
                JFLeftIconLabelCustomCell.self,
                JFLogoutCustomCell.self,
                JFHeaderCustomCell.self,
                JFFooterCustomCell.self,
                JFSwitchCustomCell.self
            ]
        )
        
        settingsTableView.estimatedRowHeight = 100
        settingsTableView.rowHeight = UITableViewAutomaticDimension
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.width, height: 50))
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("DroarNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Service call
        if facebookWorkInProgress == false {
            getSettingsData()
        }
        setupNavigation()
    }
    
    //MARK:- Helper methods
    func reloadRowsData(showFbLink: Bool = true) {
        rows = [
        .account: JFConstants.facebookDisabled
            ? [ .profilePrivacy, .currentLocation, .blockedUsers ]
            : showFbLink
            ? [ .profilePrivacy, .currentLocation, .blockedUsers ]
            : [ .profilePrivacy, .currentLocation, .blockedUsers ],
        .ratings: [.ratings],
        .notifications: [.notifications],
        .about: [.about, .terms, .privacy, .faq],
        .logout: [.logout, .delete]
        ]
    }
    
    @objc func reloadTableView() {
        reloadRowsData()
        settingsTableView.reloadData()
    }
    
    func setupNavigation() {
        title = "SETTINGS"
        //addBackButton()
    }
    
    func showFAQAndHelpVC() {
        let vc = getFAQAndHelpVC()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTermsAndPolicy() {
        let vc = getTermsAndPrivacyVC()
        vc.currentWebRequest = showTermsOrPrivacyOrAbout
        tabBarController?.present(vc, animated: true)
    }
    
    func appLogout() {
        
        UIAlertController.showAlert(inViewController: self, title: "Confirmation", message: "Are you sure you want to log out?", okButtonTitle: "Log Out", cancelButtonTitle: "Cancel"){ [weak self] success in
            if success {
                self?.logoutTapped()
            }
        }
    }
    
    func confirmDeleteAccount() {
        UIAlertController.showAlert(inViewController: self, title: "Delete Account", message: "Are you sure you want to delete your Hackfest-swvl account? \n\n If you delete your account, your data will be removed from the app.", okButtonTitle: "Yes, Delete", cancelButtonTitle: "Cancel"){ [weak self] success in
            if success {
                self?.deleteTapped()
            }
        }
    }
    
    func enterPasswordToDelete() {
        
        let alertWithTextField = UIAlertController(title: "Delete Account", message: "Please enter your password to confirm.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let textField = alertWithTextField.textFields![0] as UITextField
            
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.verifyingPassword, animated: true)
            
            let endPoint = JFUserEndpoint.verifyPassword(password: textField.text ?? "")
            
            JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<VerifyPasswordAPIBase>) in
                
                guard let strongSelf = self else { return }
                
                MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                
                if response.success {
                    if (response.data?.verifyData?.matched ?? false) { // Success
                        strongSelf.confirmDeleteAccount()
                        
                    } else { // wrong password
                        let alertType = AlertType.defaultSystemAlert(message: "You entered an incorrect password")
                        JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { [weak self] success in
                            if success {
                            }
                        }
                    }
                } else {
                    let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                    
                    JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { [weak self] success in
                        if success {
                            self?.enterPasswordToDelete()
                        }
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Cancelled")
        }
        
        alertWithTextField.addTextField(text: "", placeholder: "password", editingChangedTarget: self, editingChangedSelector: #selector(deletePasswordTextFieldChanged(_:)), keyboardType: .emailAddress, isSecureTextEntry: true)
        
        okAction.isEnabled = false
        self.actionToEnable = okAction
        
        alertWithTextField.addAction(cancelAction)
        alertWithTextField.addAction(okAction)
        
        self.tabBarController?.present(alertWithTextField, animated: true, completion: nil)
    }
    
    @objc func deletePasswordTextFieldChanged(_ textField: UITextField) {
        print("Password Text changes \(String(describing: textField.text))")
        
        self.actionToEnable?.isEnabled = ((textField.text?.count ?? 0) > 0) ? true : false
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension JFSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = rows[section]![indexPath.row]
        if let cell = getCell(for: row) {
            return cell
        }
        return UITableViewCell()
    }
    
    func getCell(for row: JFSettingRows) -> UITableViewCell? {
        switch row {
        case .profilePrivacy, .ratings:
            return getMultiLabelCell(type: row)
        default:
            return getGenericCell(for: row)
        }
    }
    
    func getMultiLabelCell(type: JFSettingRows) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "JFMultiLabelCustomCell") as! JFMultiLabelCustomCell
        cell.titleLabel.text = type.getRowText()
        
        if type == .profilePrivacy {
            if settingsData != nil {
                cell.subLabel.text = settingsData?.isPublicProfile ?? false ? "Public" : "Private"
            } else {
                cell.subLabel.text = "--"
            }
        }
        if type == .ratings {
            cell.subLabel.text = settingsData?.getRatingTextForSettings() ?? "--"
        }
        
        return cell
    }
    
    func getGenericCell(for row: JFSettingRows) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "JFSwitchCustomCell") as! JFSwitchCustomCell
        cell.configureCell(row: row, isOn: getSwitchData(for: row)) { [weak self] in
            self?.switchChanged(for: row, isOn: $0)
        }
        
        return cell
    }
    
    func getSwitchData(for row: JFSettingRows) -> Bool {
        if settingsData != nil {
            switch row {
            case .currentLocation:
                return settingsData?.locationEnabled ?? false
            case .notifications:
                return settingsData?.notificationsEnabled ?? false
            default:
                return false
            }
        }
        return false
    }
    
    func switchChanged(for row: JFSettingRows, isOn: Bool) {
        switch row {
        case .currentLocation:
            
            isOn ? enableLocationManager() : disableLocationManager()
            
            if isOn { // we are turning ON location
                if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                    case .restricted, .denied:
                        print("No access")
                        UIAlertController.showAlertWithSettingsPrompt(title: "Hackfest-swvl", message: "You are not allowed to access system Location, please allow Hackfest-swvl to access Location from Settings", fromViewController: self)
                    case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                        print("Access")
                        JFUtility.updateLocation()
 
                    }
                } else {
                    print("Location services are not enabled")
                }
            }
            
            self.allowLocationService(locationEnabled: isOn) {  [weak self] success in
                if success {
                    self?.settingsData?.locationEnabled = isOn
                    self?.settingsTableView.reloadData()
                }
            }
            
        
        case .notifications:
            self.allowNotificationService(notificationEnabled: isOn) { [weak self] success in
                if success {
                    self?.settingsData?.notificationsEnabled = isOn
                    self?.settingsTableView.reloadData()
                }
            }
            
            if isOn {// we are turning ON notification
                let current = UNUserNotificationCenter.current()
                
                current.getNotificationSettings(completionHandler: { (settings) in
                    
                    switch settings.authorizationStatus {
                    case .notDetermined:
                        DispatchQueue.main.async {
                            JFNotificationManager.shared.configure()
                        }
                        
                    case .denied:
                        DispatchQueue.main.async {
                            UIAlertController.showAlertWithSettingsPrompt(title: "Hackfest-swvl", message: "Push Notifications are turned off for Hackfest-swvl app from system settings, you can change it from Settings", fromViewController: self)
                        }
                    default:
                        break
                    }
                    
                })
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = sections[indexPath.section]
        let row = rows[section]![indexPath.row]
        
        switch row {
        case .profilePrivacy:
            if settingsData != nil {
                let vc = getProfilePrivacyVC()
                vc.settingsPrivacy = self.settingsData
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                JFAlertViewController.presentAlertController(with: AlertType.networkError, fromViewController: self.tabBarController) { [weak self] success in
                    if success {
                        self?.getSettingsData()
                    }
                }
            }
            
        case .blockedUsers:
            let vc = getBlockedUsersVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .ratings:
            if settingsData != nil {
                let vc = getRatingUsersVC()
                vc.settingsData = self.settingsData
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                JFAlertViewController.presentAlertController(with: AlertType.networkError, fromViewController: self.tabBarController) { [weak self] success in
                    if success {
                        self?.getSettingsData()
                    }
                }
            }

        case .about:
            showTermsOrPrivacyOrAbout = .about
            showTermsAndPolicy()
            
        case .terms:
            showTermsOrPrivacyOrAbout = .termsAndConditions
            showTermsAndPolicy()
            
        case .privacy:
            showTermsOrPrivacyOrAbout = .privacyPolicy
            showTermsAndPolicy()
            
        case .faq:
            showFAQAndHelpVC()
            
        case .logout:
            appLogout()
            
        case .delete:
            self.enterPasswordToDelete()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        
        switch section {
        case .about, .logout:
            return 16
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        cell.headerLabel.text = sections[section].getSectionTitle()
        return cell
    }
}

//MARK:- CLLocationManagerDelegate
extension JFSettingsViewController: CLLocationManagerDelegate {
    
    func locationAccess() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func enableLocationManager() { 
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func disableLocationManager() {
        locationManager.stopUpdatingLocation()
    }
}

//MARK:- Network calls
extension JFSettingsViewController {
    
    func getSettingsData() {
        
        if self.settingsData == nil {
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingSettings, animated: true)
        }
        
        let endPoint = JFUserEndpoint.settings
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<SettingsAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if response.success {
                guard let apiSettingsData = response.data?.settingsData else {return}
                
                strongSelf.settingsData = apiSettingsData
                (strongSelf.settingsData?.facebookConnected ?? false) ? strongSelf.reloadRowsData(showFbLink: true) : strongSelf.reloadRowsData(showFbLink: false)
                strongSelf.settingsTableView.reloadData()
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.getSettingsData()
                    }
                }
            }
        }
    }
    
    func allowLocationService(locationEnabled: Bool, completion: @escaping (_ success: Bool) -> ()) {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.updatingPreference, animated: true)
        
        JFWSAPIManager.shared.updateLocationPreference(locationEnabled: locationEnabled) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if success {
                completion(true)
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.allowLocationService(locationEnabled: locationEnabled, completion: completion)
                    }
                }
            }
        }
    }
    
    func connectFacebookService(visibility: Bool, fb_Id: String, fb_profile_link: String, completion: @escaping (_ success: Bool) -> ()) {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.updatingPreference, animated: true)
        
        let endPoint = JFUserEndpoint.connectWithFacebook(flag: visibility, facebookId: fb_Id, fbProfileLink: fb_profile_link)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success {
                completion(true)
                
            } else {
                completion(false)
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.connectFacebookService(visibility: visibility, fb_Id: fb_Id, fb_profile_link: fb_Id, completion: completion)
                    }
                }
            }
        }
    }
    
    func displayFbLinkService(visibility: Bool, completion: @escaping (_ success: Bool) -> ()) {
        
        
        let endPoint = JFUserEndpoint.fbLinkVisibility(makeFbLinkVisible: visibility)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            if response.success {
                completion(true)
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.displayFbLinkService(visibility: visibility, completion: completion)
                    }
                }
            }
        }
    }
    
    func allowNotificationService(notificationEnabled: Bool, completion: @escaping (_ success: Bool) -> ()) {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.updatingPreference, animated: true)
        
        JFWSAPIManager.shared.updateNotificationPreference(notificationEnabled: notificationEnabled) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if success {
                completion(true)
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.allowNotificationService(notificationEnabled: notificationEnabled, completion: completion)
                    }
                }
            }
        }
    }
    
    func logoutTapped() {
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loggingOut, animated: true)
        
        JFWSAPIManager.shared.logout { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if success {
                UIApplication.notificationBadgeCount = 0
                JFSession.shared.clearLogInStatus()
                
                // get a reference to the app delegate
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                
                // set root view controller to social login
                appDelegate?.setRootViewController(withAnimation: true)
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.logoutTapped()
                    }
                }
            }
        }
    }
    
    func deleteTapped() {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.deletingAccount, animated: true)
        
        let endPoint = JFUserEndpoint.delete
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if response.success {
                JFSession.shared.clearLogInStatus()
                // get a reference to the app delegate
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                
                // set root view controller to social login
                appDelegate?.setRootViewController(withAnimation: true)
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.deleteTapped()
                    }
                }
            }
        }
    }
}
