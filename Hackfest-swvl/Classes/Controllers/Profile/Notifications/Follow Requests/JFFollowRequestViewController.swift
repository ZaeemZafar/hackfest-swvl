//
//  JFFollowRequestViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/2/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFFollowRequestViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var followRequestTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    //MARK:- Public properties
    lazy var followRequests = [NotificationFollowAPIResponse]()
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for follow request vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followRequestTableView.register(UINib(nibName: "JFFollowRequestsConfirmCustomCell", bundle: nil), forCellReuseIdentifier: "JFFollowRequestsConfirmCustomCell")
        
        followRequestTableView.estimatedRowHeight = 100
        followRequestTableView.rowHeight = UITableViewAutomaticDimension
        followRequestTableView.delegate = self
        followRequestTableView.dataSource = self
        followRequestTableView.tableFooterView = UIView()

        configureTableViewForPagination()
        configureHandlerForPushNotification()
        configureAppEvents(for: [.didBecomeActive])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
        getFollowNotifications()
    }
//    
//    deinit {
//        print("Deinit called on\(String(describing: self))")
//    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "FRIEND REQUESTS"
        addBackButton()
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension JFFollowRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFFollowRequestsConfirmCustomCell") as! JFFollowRequestsConfirmCustomCell
        
        let currentProfile = followRequests[indexPath.row]
        
        cell.confirmButtonCustomCellDelegate = self
        cell.deleteButtonCustomCellDelegate = self
        cell.confirmButtonCustomCellDelegateIndexPath = indexPath
        
        if let imagePath = currentProfile.followerDetail?.image, let imageURL = URL(string: JFConstants.s3ImageURL + imagePath) {
            cell.profileImage.jf_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"))
        } else {
            cell.profileImage.image = #imageLiteral(resourceName: "profile_icon_placeholder")
        }
        
        cell.titleLabel.text = (currentProfile.followerDetail?.firstName ?? "") + " " + (currentProfile.followerDetail?.lastName ?? "")
        
        var jfIndex = "0000"
        
        if let jfIndexMultipierInfo = currentProfile.followerDetail?.indexMultiplier {
            let jfimValue = ((jfIndexMultipierInfo.jfIndex ?? 0.0) * (jfIndexMultipierInfo.jfMultiplier ?? 0.0)).rounded()
            jfIndex = "\(Int(jfimValue))".leftPadding(toLength: 4, withPad: "0")
        }
        
        cell.subTitleLabel.text = "SWVL Persona \(jfIndex)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentProfile = followRequests[indexPath.row]
        let vc = self.getUserProfileVC()
        vc.userData = JFProfile(userID: "\(currentProfile.fromUserId ?? 0)", first_name: currentProfile.followerDetail?.firstName, last_name: currentProfile.followerDetail?.lastName, image_path: currentProfile.followerDetail?.image)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- JFConfirmButtonCustomCellDelegate
extension JFFollowRequestViewController: JFConfirmButtonCustomCellDelegate {
    func deleteTapped(JFConfirmButtonCustomCell cell: JFFollowRequestsConfirmCustomCell, at indexPath: IndexPath) {
        
        UIAlertController.showAlert(inViewController: self, title: "Confirmation", message: "Are you sure you want to delete this request?", okButtonTitle: "Delete", cancelButtonTitle: "Cancel") { success in
            if success {

                let currentProfile = self.followRequests[indexPath.row]
                self.respondToRequest(withAction: false, fromProfile: currentProfile) { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.followRequests.remove(at: indexPath.row)
                        strongSelf.getFollowNotifications()
                    }
                }
            } else {
                
            }
        }
    }
    
    func confirmTapped(JFConfirmButtonCustomCell cell: JFFollowRequestsConfirmCustomCell, at indexPath: IndexPath) {
        let currentProfile = followRequests[indexPath.row]
        
        respondToRequest(withAction: true, fromProfile: currentProfile) { (success) in
            if success {
                cell.confirmButton.isHidden = true
                cell.deleteButton.isHidden = true
                cell.inNetworkButton.isHidden = false
            }
        }
    }
}

//MARK:- Network calls
extension JFFollowRequestViewController {
    func getFollowNotifications(completion: SimpleCompletionBlock? = nil) {
        self.emptyView.isHidden = true
        
        if self.followRequests.count < 1 {
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingNotifications, animated: true)
        }
        
        let endPoint = JFUserEndpoint.notificationFollowListing(page: 1, limit: 1000)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<NotificationFollowBase>) in
            completion?()
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success {
                strongSelf.followRequests.removeAll()
                
                guard let apiNotificationFollowData = response.data?.notificationFollowAPIResponse else {return}
                guard let apiMetaData = response.data?.metadata else {return}
                
                // Developer's Note: Why we are not mapping 'FollowerDetail' to 'JFProfile' to maintain consistency
                strongSelf.followRequests = apiNotificationFollowData
                strongSelf.followRequestTableView.reloadData()
                
                if apiNotificationFollowData.count < 1 {
                    strongSelf.emptyView.isHidden = false
                }
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.getFollowNotifications()
                    }
                }
            }
        }
    }
    
    func respondToRequest(withAction action: Bool, fromProfile currentProfile: NotificationFollowAPIResponse, completion:@escaping (_ success: Bool) -> ()) {
        let loaderTitle = action ? JFLoadingTitles.confirmingRequest : JFLoadingTitles.deleteRequest
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: loaderTitle, animated: true)
        
        var endPoint: JFUserEndpoint?
        
        if action {
            endPoint = JFUserEndpoint.acceptFollowRequest(userID: "\(currentProfile.friendUserId ?? 0)", requestID: "\(currentProfile.id ?? 0)")
            
        } else {
            endPoint = JFUserEndpoint.declineFollowRequest(requestID: "\(currentProfile.id ?? 0)")
        }
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint!) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            completion(response.success)
            
            if response.serverStatusCode == .notFound { //checks if user is deleted
                let alertType = AlertType.inactiveUser
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in

                    if success {
                        strongSelf.getFollowNotifications()
                    }
                }
                
            } else if response.success == false {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.respondToRequest(withAction: action, fromProfile: currentProfile, completion: completion)
                    }
                }
            }
        }
    }
}

// MARK: Table view pagination && Push Notification
extension JFFollowRequestViewController {
    
    func configureTableViewForPagination() {
        self.followRequestTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            guard let strongSelf = self else {return}
            
            strongSelf.getFollowNotifications() {
                strongSelf.followRequestTableView.cr.endHeaderRefresh()
            }
        }
    }
    
    func configureHandlerForPushNotification() {
        
        JFNotificationManager.shared.onNotificationReceive { [weak self] (notificationData) in
            
            if self?.isVisible ?? false && notificationData.triggeredFromAppLaunch == false {
                self?.getFollowNotifications() {
                    self?.followRequestTableView.cr.endHeaderRefresh()
                }
            }
            
        }
        
    }
}

// MARK:- CBAppEventsProtocol
extension JFFollowRequestViewController: CBAppEventProtocol {
    func onAppStateChange(_ state: CBAppDelegateEvent) {
        switch state {
        case .didBecomeActive:
            self.getFollowNotifications()
        default:
            break
        }
    }
}

