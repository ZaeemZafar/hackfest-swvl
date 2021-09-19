//
//  JFUserProfileViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/9/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

enum JfBlockStates: Int {
    case block = 101
    case unblock
}

enum DataSourceEnum {
    case profileInfoCell, ratingCell, anonymousRatingCell, categoryCell(trait:Trait), graphCell, profileLockedCell(state: JFCellRatingState)
}

enum RelationAction {
    case follow, unFollow, cancel
}

class JFUserProfileViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var userProfileTableView: UITableView!
    
    //MARK:- Public properties
    var userData: JFProfile!
    var userProfileLoaded = false
    var userUpdated: ((JFProfile) -> ())?
    lazy var datasourceEnumArray = [DataSourceEnum]()
    lazy var selectedGraphs = [JFIndexMultiplierType.jfIndex]

    //MARK:- Computed properties
    var blockState: JfBlockStates = .unblock {
        didSet {
            getUserProfile()
        }
    }
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for JFUserProfileViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add a observer to reload on the base of Test data
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataOnDroarNotification), name: Notification.Name("DroarNotification"), object: nil)
        
        userProfileTableView.register(identifiers: [JFProfileInfoCustomCell.self, JFUserRatingTableViewCell.self, JFAnonymousRatingsTableViewCell.self, JFCategoryCustomCell.self, JFGraphCustomCell.self,JFProfileLockedCell.self])
        
        userProfileTableView.estimatedRowHeight = 400
        userProfileTableView.rowHeight = UITableViewAutomaticDimension
        setupNavigation()
        addBackButton()
        
        setupProfileTableDataSource()
        configureTableViewForPullToRefresh()
        configureHandlerForPushNotification()
        configureAppEvents(for: [.didBecomeActive, .didEnterBackground])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setLocationButton()
        getUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
        if let cell = userProfileTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? JFProfileInfoCustomCell {
            cell.profileImage.circleView()
        }
    }
    
    //MARK:- Helper methods
    // Show or hide location button on the base Droar
    @objc func reloadDataOnDroarNotification(notification: Notification) {
        
        if self.isVisible {
            let value = notification.userInfo?["value"] as! Bool
            print("Observer call \(value)")
            
            setLocationButton()
        }
        
        userProfileTableView.reloadData()
    }
    
    @objc func locationButtonTapped() {
        if userData.locationCoodinate == nil {
            let alert = AlertType.defaultSystemAlert(message: "User's location not found.")
            JFAlertViewController.presentAlertController(with: alert, fromViewController: self, completion: nil)
            
        } else {
            JFUtility.openInMap(locationCoordinate: userData.locationCoodinate, markerTitle: userData.firstName)
        }
    }
    
    func setLocationButton() {
        if UserDefaults.standard.bool(forKey: JFConstants.JFUserDefaults.droarLocationEnabled) {
            if (navigationItem.rightBarButtonItems?.count ?? 0) == 1 {
                let locationButton = UIBarButtonItem(image: UIImage(named: "location_icon_grey"), style: .plain, target: self, action: #selector(locationButtonTapped))
                self.navigationItem.rightBarButtonItems?.append(locationButton)
            }
        } else if (navigationItem.rightBarButtonItems?.count ?? 0) > 1 {
            self.navigationItem.rightBarButtonItems?.remove(at: 1)
        }
    }
    
    func setupNavigation() {
        setNavTitle(title: userData.firstName + " " + userData.lastName)
        
        let btnRight = UIButton(type: .custom)
        btnRight.setImage(#imageLiteral(resourceName: "menu_dots_icons"), for: .normal)
        btnRight.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnRight.addTarget(self, action: #selector(blockUser), for: .touchUpInside)
        let rightButtomItem = UIBarButtonItem(customView: btnRight)
        customRightButton(button: rightButtomItem)
    }
    
    @objc func blockUser() {
        if userData.reportedByMe == false {
            UIAlertController.showSingleButtonAlert(inViewController: self, title: "", message: "", okButtonTitle: "Block", cancelButtonTitle: "Cancel", isActionSheet: true) { [weak self] (success) in
                
                guard let strongSelf = self else {return}
                
                if success {
                    UIAlertController.showAlert(inViewController: strongSelf, title: "Block \(strongSelf.userData.firstName + " " + strongSelf.userData.lastName)?", message: JFLocalizableConstants.BlockConfirmationMessage1, okButtonTitle: "Block", cancelButtonTitle: "Cancel", completion: { (success) in
                        
                        if success {
                            strongSelf.blockUserService()
                        }
                    })
                }
            }
        } else {
            
            UIAlertController.showSingleButtonAlert(inViewController: self, title: "", message: "", okButtonTitle: "Unblock", cancelButtonTitle: "Cancel", isActionSheet: true) { [weak self] (success) in
                
                guard let strongSelf = self else {return}
                
                if success {
                    UIAlertController.showAlert(inViewController: strongSelf, title: "Unblock \(strongSelf.userData.firstName + " " + strongSelf.userData.lastName)?", message: JFLocalizableConstants.UnBlockConfirmationMessage1, okButtonTitle: "Unblock", cancelButtonTitle: "Cancel", completion: { (success) in
                        
                        if success {
                            strongSelf.unblockUserService()
                        }
                    })
                }
            }
        }
    }
    
    func setupProfileTableDataSource() {
        datasourceEnumArray.removeAll()
        datasourceEnumArray.append(.profileInfoCell)
        
        if userData.reportedByThem {
            datasourceEnumArray.append(DataSourceEnum.profileLockedCell(state: .blocked))
            
        } else {
            if userData.profilePrivacy == .publicProfile || userData.followingState == .following {
                datasourceEnumArray.append(.ratingCell)
                
                if (userData.acceptRating == false) {
                    datasourceEnumArray.append(DataSourceEnum.profileLockedCell(state: .ratingDisabled))
                    return
                }
                
                if userData.acceptAnonymousRating == false {
                    datasourceEnumArray.append(.anonymousRatingCell)
                }
                
                datasourceEnumArray.append(.graphCell)
                
                
                if userData.trait[.friendly] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .friendly))
                }
                if userData.trait[.dressing] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .dressing))
                }
                if userData.trait[.iqLevel] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .iqLevel))
                }
                if userData.trait[.communication] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .communication))
                }
                if userData.trait[.personality] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .personality))
                }
                if userData.trait[.behavior] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .behavior))
                }
                if userData.trait[.cleanliness] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .cleanliness))
                }
                if userData.trait[.punctuality] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .punctuality))
                }
                if userData.trait[.appearance] ?? false {
                    datasourceEnumArray.append(.categoryCell(trait: .appearance))
                }

            }
            
//            if userData.profilePrivacy == .privateProfile {
//                
//                switch userData.followingState {
//                case .none, .requested:
//                    
//                    if (userData.acceptRating) {
//                        datasourceEnumArray.append(DataSourceEnum.profileLockedCell(state: .bothLocked))
//                        
//                    } else {
//                        datasourceEnumArray.append(DataSourceEnum.profileLockedCell(state: .ratingReceiveDisabled))
//                    }
//                    
//                case .following:
//                    
//                    if (userData.acceptRating == false) {
//                        datasourceEnumArray.append(DataSourceEnum.profileLockedCell(state: .ratingDisabled))
//                    }
//                }
//            }
        }
    }
    
    func cellfor(type: DataSourceEnum) -> UITableViewCell {
        
        switch type {
        case .profileInfoCell:
            let cell = self.userProfileTableView.dequeueReusableCell(withIdentifier: "JFProfileInfoCustomCell") as! JFProfileInfoCustomCell
            cell.configureCellWithData(data: userData)
            
            cell.buttonTappedForState = { [weak self] buttonAction in
                guard let strongSelf = self else { return }
                switch buttonAction {
                case .follow:
                    print("Follow action tapped")
                    
                    strongSelf.sendRelationRequest(relationAction: .follow)
                    
                case .following:
                    print("Prompt for un-follow")
                    
                    UIAlertController.showAlert(inViewController: strongSelf, title: "", message: "If you change your mind, you'll have to request to follow \(strongSelf.userData.firstName + " " + strongSelf.userData.lastName) again.", okButtonTitle: "Unfollow", cancelButtonTitle: "Cancel", isActionSheet: true, isButtonTypeDestructive: true, isSingleButtonAlert: false, completion: { (success) in
                        
                        if success {
                            strongSelf.sendRelationRequest(relationAction: .unFollow)
                        }
                        
                    })
                    
                case .requested:
                    print("Requested Button Tapped")
                    strongSelf.sendRelationRequest(relationAction: .cancel)
                    
                default:
                    break
                }
            }
            
            return cell
            
        case .categoryCell(let trait):
            let cell = self.userProfileTableView.dequeueReusableCell(withIdentifier: "JFCategoryCustomCell") as! JFCategoryCustomCell
            let isSelected = isRowTypeSelected(rowType: trait.typeDataSource)
            cell.configureCell(withProfile: userData, forType: trait.typeDataSource, isSelected: isSelected)
            
            return cell
            
        case .anonymousRatingCell:
            let cell = self.userProfileTableView.dequeueReusableCell(withIdentifier: "JFAnonymousRatingsTableViewCell") as! JFAnonymousRatingsTableViewCell
            return cell
            
        case .profileLockedCell(let state):
            let cell = self.userProfileTableView.dequeueReusableCell(withIdentifier: "JFProfileLockedCell") as! JFProfileLockedCell
            cell.configureCellWithData(state: state)
            return cell
            
        case .ratingCell:
            let cell = self.userProfileTableView.dequeueReusableCell(withIdentifier: "JFUserRatingTableViewCell") as! JFUserRatingTableViewCell
            
            cell.configureCellWithState(forProfile: userData)
            
            print("Request AGain in \(userData.secondsToRequestAgain) Rate AGain in \(userData.secondsToRateAgain) ")
            
            if userData.secondsToRateAgain > 1 {
                DispatchTime.executeAfter(seconds: userData.secondsToRateAgain) { [weak self] in
                    self?.userProfileTableView.reloadData()
                }
            }
            
            if userData.secondsToRequestAgain > 1 {
                DispatchTime.executeAfter(seconds: userData.secondsToRequestAgain) { [weak self] in
                    self?.userProfileTableView.reloadData()
                }
            }
            
            cell.cellButtonAction = { [weak self] action in
                guard let strongSelf = self else { return }
                
                switch action {
                    
                case .rateAgain:
                    
                    if strongSelf.userData.reportedByMe == false {
                        
                        if strongSelf.userData.canRateAgain {
                            if strongSelf.userData.trait.count > 0 { //just to check if data loads on this viewController
                                let chooseVC = strongSelf.getRatingCategoryVC()
                                chooseVC.ratedUser = strongSelf.userData
                                chooseVC.ratingAgain = true
                                let navigationController = UINavigationController(rootViewController: chooseVC)
                                strongSelf.present(navigationController, animated: true, completion: nil)
                            } else {
                                JFAlertViewController.presentAlertController(with: AlertType.networkError, fromViewController: strongSelf.tabBarController) { success in
                                    if success {
                                        strongSelf.getUserProfile()
                                    }
                                }
                            }
                        } else {
                            JFAlertViewController.presentAlertController(with: .rateUser(userName: strongSelf.userData.fullName), fromViewController: strongSelf.tabBarController, completion:nil)
                        }
                    } else {
                        UIAlertController.showOkayAlert(inViewController: strongSelf.tabBarController!, message: "User is blocked by you. You cannot rate them.")
                    }
                    
                case .requestRating:
                    
                    if strongSelf.userData.reportedByMe == false {
                        JFAlertViewController.presentAlertController(with: AlertType.requestRating(userName: strongSelf.userData.fullName), fromViewController: strongSelf.tabBarController) { success in
                            if success {
                                
                                let endPoint = JFUserEndpoint.requestRating(userId: strongSelf.userData.id)
                                MBProgressHUD.showCustomHUDAddedTo(view: strongSelf.tabBarController?.view, title: JFLoadingTitles.wait, animated: true)
                                
                                JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint, completion: { (response: JFWepAPIResponse<GenericResponse>) in
                                    MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
                                    
                                    if response.success {
                                        MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.tabBarController?.view)!, title: "Request sent", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                                            strongSelf.getUserProfile()
                                        })
                                        
                                    } else {
                                        
                                        let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                                        
                                        JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                                            if success {
                                                // stuck
                                                //strongSelf.cellfor(type: type)
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    } else {
                        UIAlertController.showOkayAlert(inViewController: strongSelf.tabBarController!, message: "User is blocked by you. You cannot request rating from them.")
                    }
                    
                case .requestAgain:
                    
                    if strongSelf.userData.reportedByMe == false {
                        
                        if strongSelf.userData.canRequestAgain {
                            
                            JFAlertViewController.presentAlertController(with: AlertType.requestRating(userName: strongSelf.userData.fullName), fromViewController: strongSelf.tabBarController) { success in
                                if success {
                                    
                                    let endPoint = JFUserEndpoint.requestRating(userId: strongSelf.userData.id)
                                    MBProgressHUD.showCustomHUDAddedTo(view: strongSelf.tabBarController?.view, title: JFLoadingTitles.wait, animated: true)
                                    JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint, completion: { (response: JFWepAPIResponse<GenericResponse>) in
                                        MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
                                        
                                        if response.success {
                                            MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.tabBarController?.view)!, title: "Request sent again", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                                MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                                                strongSelf.getUserProfile()
                                            })
                                            
                                        } else {
                                            let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                                            
                                            JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                                                if success {
                                                    // stuck
                                                    //strongSelf.cellfor(type: type)
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        } else {
                            JFAlertViewController.presentAlertController(with: AlertType.requestRatingTimeError(userName: strongSelf.userData.fullName), fromViewController: strongSelf.tabBarController, completion: nil)
                        }
                    } else {
                        UIAlertController.showOkayAlert(inViewController: strongSelf.tabBarController!, message: "User is blocked by you. You cannot request rating from them.")
                    }
                    
                case .rateUser:
                    if strongSelf.userData.reportedByMe == false {
                        // TODO: Jawad! why we are doing this!!
                        //                        if strongSelf.userData.trait.count > 0 {
                        let chooseVC = strongSelf.getRatingCategoryVC()
                        chooseVC.ratedUser = strongSelf.userData
                        let navigationController = UINavigationController(rootViewController: chooseVC)
                        strongSelf.present(navigationController, animated: true, completion: nil)
                        //                        } else {
                        //                            JFAlertViewController.presentAlertController(with: AlertType.networkError, fromViewController: strongSelf.tabBarController, completion: {
                        //                                strongSelf.getUserProfile()
                        //                            })
                        //                        }
                    } else {
                        UIAlertController.showOkayAlert(inViewController: strongSelf.tabBarController!, message: "User is blocked by you. You cannot rate them.")
                    }
                }
            }
            
            return cell
            
        case .graphCell:
            let cell = self.userProfileTableView.dequeueReusableCell(withIdentifier: "JFGraphCustomCell") as! JFGraphCustomCell
            
            cell.configure(with: userData, types: selectedGraphs)
            
            return cell
        }
    }
    
    func isRowTypeSelected(rowType: MyProfileTableDataSourceEnum) -> Bool {
        switch rowType {
        case .friendly: return selectedGraphs.contains(.friendly)
        case .dressing: return selectedGraphs.contains(.dressing)
        case .iqLevel: return selectedGraphs.contains(.iqLevel)
        case .communication: return selectedGraphs.contains(.communication)
        case .personality: return selectedGraphs.contains(.personality)
        case .behavior: return selectedGraphs.contains(.behavior)
        case .cleanliness: return selectedGraphs.contains(.cleanliness)
        case .punctuality: return selectedGraphs.contains(.punctuality)
        case .appearance: return selectedGraphs.contains(.appearance)
        
        default:
            return false
        }
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
extension JFUserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasourceEnumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = datasourceEnumArray[indexPath.row]
        
        return cellfor(type: type)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = tableView.cellForRow(at: indexPath) as? JFCategoryCustomCell {
            let type = datasourceEnumArray[indexPath.row]
            
            switch type {
            case .categoryCell(trait: let aTrait):
                selectedGraphs.setGraphType(graphType: aTrait.indexMultiplierType)
            default:
                break
            }
            tableView.reloadData()
        }
    }
}

//MARK:- Network calls
extension JFUserProfileViewController {
    
    func requestRating() {
        JFAlertViewController.presentAlertController(with: .requestRating(userName: userData.fullName), fromViewController: self.tabBarController) { success in
            if success {
            }
        }
    }
    
    func getUserProfile(completionHandler completion: SimpleCompletionBlock? = nil) {
        let userID = userData.id
        let endPoint = JFUserEndpoint.userProfile(userID: "\(userID)")
        
        if userProfileLoaded == false {
            userProfileLoaded = true
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingProfile, animated: true)
        }
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<NetworkProfileBase>) in
            completion?()
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success {
                
                guard let apiProfileData = response.data?.networkProfileAPIResponse else { return }
                strongSelf.userData = JFProfile(profileData: apiProfileData, graphDataRetrieved: {
                    self?.userProfileTableView.reloadData()
                })
                
                strongSelf.userUpdated?(strongSelf.userData)
                strongSelf.setupProfileTableDataSource()
                strongSelf.userProfileTableView.reloadData()
                
            } else if response.serverStatusCode == .notFound {
                let alertType = AlertType.inactiveUser
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.popViewController()
                    }
                }
            } else {
                
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { _ in
                    strongSelf.getUserProfile(completionHandler: completion)
                }
            }
            
        }
    }
    
    func sendRelationRequest(relationAction: RelationAction ) {
        let userID = userData.id
        var loadingText = ""
        
        switch relationAction {
        case .follow:
            loadingText = JFLoadingTitles.sendingFollowingRequest
        case .unFollow:
            loadingText = JFLoadingTitles.sendingUnFollowingRequest
        case .cancel:
            loadingText = JFLoadingTitles.sendingCancellingRequest
        }
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: loadingText, animated: true)
        
        var endPoint: JFUserEndpoint
        
        switch relationAction {
        case .follow:
            endPoint = JFUserEndpoint.followUser(userID: "\(userID)")
        case .unFollow:
            endPoint = JFUserEndpoint.unFollowUser(userID: "\(userID)")
        case .cancel:
            endPoint = JFUserEndpoint.cancelFollowRequest(targetUserId: "\(userID)")
        }
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if response.success {
                
                if relationAction == .follow {
                    strongSelf.userData.followingState = strongSelf.userData.profilePrivacy == .publicProfile ? .following: .requested
                } else {
                    strongSelf.userData.followingState = .none
                }
                
                strongSelf.userUpdated?(strongSelf.userData)
                
                strongSelf.setupProfileTableDataSource()
                strongSelf.userProfileTableView.reloadData()
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.sendRelationRequest(relationAction: relationAction)
                    }
                }
            }
        }
    }
    
    func blockUserService() {
        
        MBProgressHUD.showCustomHUDAddedTo(view: (self.tabBarController?.view)!, title: JFLoadingTitles.blockingUser, animated: true)
        
        let endPoint = JFUserEndpoint.block(targetUserId: self.userData.id)
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if response.success {
                
                UIAlertController.showAlert(inViewController: strongSelf, title: "\(strongSelf.userData.firstName + " " + strongSelf.userData.lastName) Blocked", message: JFLocalizableConstants.BlockConfirmationMessage2, okButtonTitle: "", cancelButtonTitle: "Dismiss", isActionSheet: false, isButtonTypeDestructive: false, isSingleButtonAlert: true, completion: { (success) in
                    
                    strongSelf.userData.reportedByMe = true
                    strongSelf.getUserProfile()
                    //strongSelf.userProfileTableView.reloadData()
                    
                })
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.blockUserService()
                    }
                }
            }
        }
    }
    
    func unblockUserService() {
        
        MBProgressHUD.showCustomHUDAddedTo(view: (self.tabBarController?.view)!, title: JFLoadingTitles.unblockingUser, animated: true)
        
        let endPoint = JFUserEndpoint.unblock(blockUserId: self.userData.id)
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if response.success { // successfully unblocked
                UIAlertController.showAlert(inViewController: strongSelf, title: "\(strongSelf.userData.firstName + " " + strongSelf.userData.lastName) Unblocked", message: JFLocalizableConstants.UnBlockConfirmationMessage2, okButtonTitle: "", cancelButtonTitle: "Dismiss", isActionSheet: false, isButtonTypeDestructive: false, isSingleButtonAlert: true, completion: { (success) in
                    
                    strongSelf.userData.reportedByMe = false
                    strongSelf.getUserProfile()
                    //strongSelf.userProfileTableView.reloadData()
                })
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.unblockUserService()
                    }
                }
            }
        }
    }
}

extension JFUserProfileViewController {
    func configureTableViewForPullToRefresh() {
        self.userProfileTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.getUserProfile(completionHandler: {
                strongSelf.userProfileTableView.cr.endHeaderRefresh()
            })
        }
    }
    
    func configureHandlerForPushNotification() {
        
        JFNotificationManager.shared.onNotificationReceive { [weak self] (notificationData) in
            
            if self?.isVisible ?? false &&
                notificationData.triggeredFromAppLaunch == false &&
                notificationData.userID == self?.userData.id {
                self?.getUserProfile(completionHandler: nil)
            }
        }
    }
}

// MARK:- CBAppEventsProtocol
extension JFUserProfileViewController: CBAppEventProtocol {
    
    func onAppStateChange(_ state: CBAppDelegateEvent) {
        
        // Developer's Note: We have observed a memory leak due to which this view controller won't de-allocats from memory. For now, we are simply adding a security check to update profile if user is login
        // TODO: Find and resolve memory leak
        if JFSession.shared.isLogIn() == false {
            NotificationCenter.default.removeObserver(self)
            
            return
        }
        
        if state == .didBecomeActive && isVisible {
            self.getUserProfile(completionHandler: nil)
        }
    }
}
