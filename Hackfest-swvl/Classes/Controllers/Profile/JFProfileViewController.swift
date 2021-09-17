//
//  JFProfileViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/26/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import Droar

enum MyProfileTableDataSourceEnum: Int, CaseIterable {
    case profileInfo = 0, graph, appearanceCategory, personalityCategory, intelligenceCategory
    
    var indexUI: (icon: UIImage, text: String) {
        switch self {
        case .personalityCategory:
            return ( #imageLiteral(resourceName: "personality_icon_lightred"), "Personality")
        case .appearanceCategory:
            return ( #imageLiteral(resourceName: "appearance_icon_yellow") ,"Appearance")
        case .intelligenceCategory:
            return ( #imageLiteral(resourceName: "intelligence_bulb_icon_lightblue") , "Intelligence")
        default:
            return (UIImage(), "")
        }
    }
    
    var highLightColor: UIColor {
        switch self {
        case .personalityCategory:
            return UIColor.jfCategoryRed
        case .appearanceCategory:
            return UIColor.jfCategoryOrange
        case .intelligenceCategory:
            return UIColor.jfCategoryBlue
        default:
            return UIColor.clear
        }
    }
    
    var indexMultiplierType: JFIndexMultiplierType {
        switch self {
        case .appearanceCategory:
            return JFIndexMultiplierType.appearance
            
        case .intelligenceCategory:
            return JFIndexMultiplierType.intelligence
            
        case .personalityCategory:
            return JFIndexMultiplierType.personality
            
        default:
            return JFIndexMultiplierType.jfIndex
        }
    }
}

class JFProfileViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profileTableView: UITableView!
    
    //MARK:- Public properties
    lazy var selectedGraphs = [JFIndexMultiplierType.jfIndex]
    lazy var profileTableDataSource = [MyProfileTableDataSourceEnum]()
    
    //MARK:- Private properties
    var shouldUpdatePreferences = true
    var loadingProfile = false
    
    //MARK:- Computed properties
    var profileInfo: ProfileInfo {
        get {
            if let info = JFSession.shared.myProfile {
                return info
            } else {
                return ProfileInfo()
            }
        }
    }
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for JFProfileViewController")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add a observer to reload on the base of Test data
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromDroarNotification), name: Notification.Name("DroarNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setUpMultiplier), name: Notification.Name("DroarMultiplierNotification") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setRatingsHistory), name: Notification.Name("DroarRatingsHistoryNotification") , object: nil)

        
        profileTableView.register(identifiers: [JFProfileInfoCustomCell.self, JFCategoryCustomCell.self, JFGraphCustomCell.self])
        
        profileTableView.estimatedRowHeight = 500
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        profileTableView.reloadData()
        
        registerNotificationObservers()
        configureTableViewForPagination()
        configureHandlerForPushNotification()
        setupDataSource()
        configureAppEvents(for: [.willEnterForeground, .didBecomeActive])
        updateNotificationCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setLocationButton()
        // 0 mean we have dummy data and profile data is yet to be retrieved from server
        let shouldShowLoader = profileInfo.id == "0"
        setupNavigationBar()
        
        getProfileData(showHud: shouldShowLoader, completion: { [weak self] (profileLoaded) in
            let fromSignup = (self?.tabBarController as? JFTabbarViewController)?.fromSignUpProcess ?? false
            let shouldCallPreferenceUpdate = (self?.shouldUpdatePreferences ?? false) && (fromSignup == false)
            
            if profileLoaded && shouldCallPreferenceUpdate {
                self?.shouldUpdatePreferences = false
                
                JFUtility.updateUserLocationToServer(completion: { (success, locationCoordinate) in
                    JFSession.shared.myProfile?.locationCoodinate = locationCoordinate
                    
                    self?.profileTableView.reloadData()
                })
                
                JFNotificationManager.shared.configure()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        if let cell = profileTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? JFProfileInfoCustomCell {
            cell.profileImage.circleView()
        }
    }

    //MARK:- Helper methods
    // Show or hide location button on the base Droar
    @objc func reloadDataFromDroarNotification(notification: Notification) {
        
        if self.isVisible {
            let value = notification.userInfo?["value"] as! Bool
            print("Observer call \(value)")
            
            setLocationButton()
        }
        
        profileTableView.reloadData()
    }
    
    @objc func setUpMultiplier(notification: Notification) {
        Droar.dismissWindow()
        
        let multiplierVC = getMultiplierVC()
        
        tabBarController?.present(multiplierVC, animated: true, completion: nil)
    }
    
    @objc func setRatingsHistory(notification: Notification) {
        Droar.dismissWindow()
        
        let ratingsHistoryVC = getRatingsHistoryVC()
        
        tabBarController?.present(ratingsHistoryVC, animated: true, completion: nil)
    }
    
    @objc func locationButtonTapped() {
        if profileInfo.locationCoodinate == nil {
            let alert = AlertType.defaultSystemAlert(message: "User's location not found.")
            JFAlertViewController.presentAlertController(with: alert, fromViewController: self, completion: nil)
            
        } else {
            JFUtility.openInMap(locationCoordinate: profileInfo.locationCoodinate, markerTitle: JFSession.shared.myProfile?.firstName ?? "User location")
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "MY PROFILE"
        
        configureRightBarButton()
    }
    
    func setupDataSource() {
        profileTableDataSource.removeAll()
        profileTableDataSource.append(contentsOf: [.profileInfo, .graph])
        
        if profileInfo.traitAppearance { profileTableDataSource.append(.appearanceCategory) }
        if profileInfo.traitPersonality { profileTableDataSource.append(.personalityCategory) }
        if profileInfo.traitIntelligence { profileTableDataSource.append(.intelligenceCategory) }
    }
    
    @objc func openNotifications() {
        let vc = self.getNotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToEditProfile() {
        let vc = getEditProfileVC()
        vc.userInfo = profileInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func isRowTypeSelected(rowType: MyProfileTableDataSourceEnum) -> Bool {
        switch rowType {
        case .appearanceCategory:
            return selectedGraphs.contains(.appearance)
        
        case .intelligenceCategory:
            return selectedGraphs.contains(.intelligence)
            
        case .personalityCategory:
            return selectedGraphs.contains(.personality)
            
        default:
            return false
        }
    }
    
    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(emailUpdatedNotification(notification:)), name: JFConstants.Notifications.emailUpdated, object: nil)
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
    
    func configureRightBarButton() {
        print("Notification Badge Count \(UIApplication.notificationBadgeCount)")
        let btn = UIButton(type: .custom)
        let imageName = UIApplication.hasNotifications ? "more_icon_grey_yellow_white_with_notification" : "more_icon_grey_white"
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btn.addTarget(self, action: #selector(openNotifications), for: .touchUpInside)
        let rightButtomItem = UIBarButtonItem(customView: btn)
        customRightButton(button: rightButtomItem)
    }
    
    func updateNotificationCount() {
        
        JFWSAPIManager.shared.getNotificationCount(forType: .pushNotification, completion: { [weak self] (success, errorMessage, count) in
            guard let strongSelf = self else { return }
            
            if success {
                UIApplication.notificationBadgeCount = count
                strongSelf.configureRightBarButton()
                
            } else {
                
            }
        })
    }
    
    @objc func emailUpdatedNotification(notification: Notification){
        if JFSession.shared.isLogIn() {
            getProfileData(showHud: false)
        }
    }
    
    func configureHandlerForPushNotification() {
        
        JFNotificationManager.shared.onNotificationReceive { [weak self]  (notificationData) in
            guard let strongSelf = self else { return }
            
            // Update Notification badge icon:
            // Developer's Note:
            // Without 500 miliseconds delay, UIApplication badge count property won't return the latest value
            DispatchTime.executeAfter(milliSeconds: 500, completionHandler: {
                strongSelf.configureRightBarButton()
            })
            
            if notificationData.triggeredFromAppLaunch {
                
                // Avoid if some high priority activity is in progress e.g. User is submitting rating
                if (UIApplication.topViewController()?.isModal() ?? false) {
                    return
                }
                
                strongSelf.tabBarController?.selectedIndex = 0

                DispatchTime.executeAfter(milliSeconds: 300, completionHandler: {
                    strongSelf.navigationController?.popToRootViewController(animated: false)
                    var viewControllerToPush = [UIViewController]()
                    
                    viewControllerToPush.append(strongSelf.getNotificationsVC())
                    
                    if notificationData.type == .followRequest {
                        viewControllerToPush.append(strongSelf.getFollowRequestNotificationVC())
                    }
                    
                    strongSelf.navigationController?.pushViewControllers(viewControllerToPush, animated: true)
                })
                
            } else {
                
                if strongSelf.isVisible {
                    strongSelf.getProfileData(showHud: false, completion: nil)
                }
            }
        }
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
extension JFProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = profileTableDataSource[safe: indexPath.row] else {return UITableViewCell()}
        
        let cell = getCellWithConfiguration(forRow: rowType)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rowType = profileTableDataSource[safe: indexPath.row] else {return}
        
        // We have no action to perform on row following row types
        if rowType == .graph || rowType == .profileInfo {
            return
        }
        
        selectedGraphs.setGraphType(graphType: rowType.indexMultiplierType)
        
        tableView.reloadData()
    }
    
    func getCellWithConfiguration(forRow rowType: MyProfileTableDataSourceEnum) -> UITableViewCell {
        
        switch rowType {
        case .profileInfo:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: String(describing: JFProfileInfoCustomCell.self)) as! JFProfileInfoCustomCell
            
            cell.configureCellWithData(data: profileInfo)
            cell.buttonTappedForState = { [weak self] state in
                if state == .editProfile {
                    // Edit Profile button tapped
                    self?.navigateToEditProfile()
                }
            }
            
            return cell
            
        case .graph:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "JFGraphCustomCell") as! JFGraphCustomCell
            cell.configure(with: profileInfo, types: selectedGraphs)
            return cell
            
        case .intelligenceCategory, .appearanceCategory, .personalityCategory:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "JFCategoryCustomCell") as! JFCategoryCustomCell
            
            let isSelected = isRowTypeSelected(rowType: rowType)
            cell.configureCell(withProfile: profileInfo, forType: rowType, isSelected: isSelected)
            
            return cell
        }

    }
}

//MARK:- Network calls
extension JFProfileViewController {
    
    func getProfileData(showHud: Bool = true, completion: CompletionBlockWithBool? = nil) {
        
        if loadingProfile {
            return
        }
        
        loadingProfile = true
        
        if showHud {
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingProfile, animated: true)
        }
        
        JFWSAPIManager.shared.profile(graphRetrieved: { [weak self] in
            self?.loadingProfile = false
            self?.setupDataSource()
            self?.profileTableView.reloadData()
            
        }, completion: {  [weak self] (success, profileInfo, errorMessage) in
            guard let strongSelf = self else { return }
            
            if showHud {
                MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            }
            
            if success {
                
                if let _ = profileInfo {
                    JFSession.shared.myProfile = profileInfo
                    
                    strongSelf.setupDataSource()
                    strongSelf.profileTableView.reloadData()
                }
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.getProfileData(showHud: showHud)
                    }
                }
            }
            
            completion?(success)
        })
    }
}

// MARK:- Table view pagination
extension JFProfileViewController {
    
    func configureTableViewForPagination() {
        self.profileTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            guard let strongSelf = self else {return}

            strongSelf.getProfileData(showHud: false) { success in
                strongSelf.profileTableView.cr.endHeaderRefresh()
            }
        }
    }
}

// MARK:- CBAppEventsProtocol
extension JFProfileViewController: CBAppEventProtocol {
    func onAppStateChange(_ state: CBAppDelegateEvent) {
        configureRightBarButton()
        
        // Developer's Note: We have observed a memory leak due to which this view controller won't de-allocats from memory. For now, we are simply adding a security check to update profile if user is login
        // TODO: Find and resolve memory leak
        if JFSession.shared.isLogIn() == false {
            NotificationCenter.default.removeObserver(self)
            
            return
        }
        
        if state == .didBecomeActive && isVisible {
            getProfileData(showHud: false) { (success) in
                
                // Update location if needed
                JFUtility.updateUserLocationToServer(alertsAllowed: false) { [weak self] (success, location) in
                    if success {
                        JFSession.shared.myProfile?.locationCoodinate = location
                        
                        self?.profileTableView.reloadData()
                    }
                }
            }
        }
    }
}
