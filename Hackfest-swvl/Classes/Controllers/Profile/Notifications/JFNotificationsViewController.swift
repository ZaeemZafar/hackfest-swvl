//
//  JFNotificationsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/29/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

private enum JFNotificationSections: Int {
    case followRequests = 0
    case notifications
    case total
}

private enum JFNotificationSectionsFollowRequests: Int {
    case followRequests = 0
    case total
}

private enum JFNotificationSectionEmpty: Int {
    case count = 0
}

class JFNotificationsViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    var rightButtomItem = UIBarButtonItem()
    
    //MARK:- Public properties
    lazy var notificationslist = [NotificationData]()
    var followNotificationCount = 0
    
    //MARK:- UITableViewCell lifecycle
    deinit {
        print("Deinit called for notifications vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add a observer to reload on the base of Test data
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("DroarNotification") , object: nil)
        
        notificationsTableView.register(identifiers: [JFFollowRequestBasicCustomCell.self, JFNotificationsCustomCell.self, JFHeaderCustomCell.self])

        notificationsTableView.estimatedRowHeight = 100
        notificationsTableView.rowHeight = UITableViewAutomaticDimension
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.tableFooterView = UIView()
        configureTableViewForPagination()
        configureHandlerForPushNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
        updateFollowNotificationCount()
        getNotificationData()
        UIApplication.notificationBadgeCount = 0
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "NOTIFICATIONS"
        addClearAllButton()
        addBackButton()
    }
    
    func addClearAllButton() {
        rightButtomItem = UIBarButtonItem(title: JFLocalizableConstants.ClearAll, style: .plain, target: self, action: #selector(clearAllButtonTapped))
        rightButtomItem.tintColor = UIColor.jfDarkGray
        rightButtomItem.isEnabled = false
        customRightButton(button: rightButtomItem)
    }
    
    @objc func clearAllButtonTapped() {
        UIAlertController.showAlert(inViewController: self, title: "Confirmation", message: "Are you sure you want to clear all notifications?", okButtonTitle: "Yes", cancelButtonTitle: "Cancel"){ success in
            if success {
                self.clearAllNotificationsService()
            }
        }
    }
    
    func showFollowRequestsVC() {
        let vc = self.getFollowRequestNotificationVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // reloadData on the base Droar
    @objc func reloadData(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        if value  {
            notificationsTableView.isHidden = false
            emptyView.isHidden = true
        } else {
            notificationsTableView.isHidden = true
            emptyView.isHidden = false
        }
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension JFNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return JFNotificationSections.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case JFNotificationSections.followRequests.rawValue:
            return JFNotificationSectionsFollowRequests.total.rawValue
        case JFNotificationSections.notifications.rawValue:
            return notificationslist.count
        default:
            return JFNotificationSectionEmpty.count.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == JFNotificationSections.followRequests.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JFFollowRequestBasicCustomCell") as! JFFollowRequestBasicCustomCell
            
            cell.numberOfRequestsLabel.text = followNotificationCount > 0 ? String(followNotificationCount) : "0"
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JFNotificationsCustomCell") as! JFNotificationsCustomCell
            
            let currentNotification = notificationslist[indexPath.row]
            cell.titleLabel.text = currentNotification.notificationDetail?.title ?? ""
            cell.subTitleLabel.text = currentNotification.notificationDetail?.description
            cell.timeLabel.text = currentNotification.createdDate?.jfToStringWithRelativeTime()
            
            cell.newNotificationIndicator.newNotificaton = !(currentNotification.isSeen ?? true)
            
            if currentNotification.type == .anonymousRated {
                cell.profileImageView.image = #imageLiteral(resourceName: "portfolio_icon_light_grey").withRenderingMode(.alwaysTemplate)
                cell.profileImageView.tintColor = .jfLightGray
                cell.profileImageView.contentMode = .center
                
            } else {
                cell.profileImageView.contentMode = .scaleAspectFit
                
                if let imageURL = currentNotification.senderInfo?.imageURL(thumbnail: true) {
                    cell.profileImageView.jf_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"))
                } else {
                    cell.profileImageView.image = #imageLiteral(resourceName: "profile_icon_placeholder")
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        
        cell.headerLabel.text = "Recent Activity"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == JFNotificationSections.notifications.rawValue {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == JFNotificationSections.followRequests.rawValue {
            showFollowRequestsVC()
        } else {
            
            let notificationItem = notificationslist[indexPath.row]
            
            if notificationItem.type != .anonymousRated {
                let vc = self.getUserProfileVC()
                vc.userData = notificationslist[indexPath.row].senderInfo
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}

//MARK:- Network calls
extension JFNotificationsViewController {
    
    func updateFollowNotificationCount() {
        
        JFWSAPIManager.shared.getNotificationCount(forType: .followNotification, completion: { [weak self] (success, errorMessage, count) in
            guard let strongSelf = self else { return }
            
            if success {
                strongSelf.followNotificationCount = count
                strongSelf.notificationsTableView.reloadData()
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.updateFollowNotificationCount()
                    }
                }
            }
        })
    }
    
    func getNotificationData(completion: SimpleCompletionBlock? = nil) {
        emptyView.isHidden = true
        
        let endPoint = JFUserEndpoint.notificationsListing(page: 1, limit: 200)
        
        if notificationslist.count < 1 {
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingNotifications, animated: true)
        }
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint, completion: { [weak self] (response: JFWepAPIResponse<NotificationListBaseResponse>) in
            completion?()
            guard let strongSelf = self else {return}
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success {
                guard let notificationListing = response.data?.notificationData else { return }
                strongSelf.notificationslist = notificationListing
                strongSelf.rightButtomItem.isEnabled = strongSelf.notificationslist.count > 0 ? true : false
                strongSelf.notificationsTableView.reloadData()
                if strongSelf.notificationslist.count < 1 {
                    strongSelf.emptyView.isHidden = false
                }
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.getNotificationData()
                    }
                }
            }
        })
    }
    
    func clearAllNotificationsService() {
        let endPoint = JFUserEndpoint.notificationsClearAll
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint, completion: { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            if response.success {
                strongSelf.notificationslist = [NotificationData]()
                strongSelf.rightButtomItem.isEnabled = false
                strongSelf.emptyView.isHidden = false
                strongSelf.notificationsTableView.reloadData()
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.clearAllNotificationsService()
                    }
                }
            }
        })
    }
}

//MARK:- Table Pagination/notification listeners
extension JFNotificationsViewController {
    
    func configureTableViewForPagination() {
        self.notificationsTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.updateFollowNotificationCount()
            strongSelf.getNotificationData() { [weak self] in
                self?.notificationsTableView.cr.endHeaderRefresh()
            }
        }
    }
    
    func configureHandlerForPushNotification() {
        
        JFNotificationManager.shared.onNotificationReceive { [weak self] (notificationData) in
            
            if self?.isVisible ?? false && notificationData.triggeredFromAppLaunch == false {
                self?.updateFollowNotificationCount()
                self?.getNotificationData()
            }
        }
    }
}
