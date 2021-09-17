//
//  JFPortFolioVC.swift
//  Hackfest-swvl
//
//  Created by zaktech on 7/24/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

enum AnimationDirection {
    case rightToLeft, leftToRight
}

enum SelectedCategory: Int, CaseIterable {
    case following = 0
    case myNetworks
    case discover
    
    func getLoadingText() -> String {
        switch self {
        case .discover:
            return JFLoadingTitles.loadingDiscoverData
            
        case .myNetworks:
            return JFLoadingTitles.loadingNetworkData
            
        case .following:
            return JFLoadingTitles.loadingFollowing
        }
    }
    
    func getUserEndPoint(currentPage: Int, searchString: String = "") -> JFUserEndpoint {
        switch self {
        case .discover:
            let userFilter = UserFilter()
            userFilter.page = currentPage
            userFilter.limit = JFConstants.paginationPageLimit
            userFilter.search = ""
            userFilter.sort = .highestToLowest
            let endPoint = JFUserEndpoint.discover(filter: userFilter)
            
            return endPoint
            
        case .myNetworks:
            return JFUserEndpoint.getMyNetwork(page: currentPage, limit: JFConstants.paginationPageLimit)
            
        case .following:
            return JFUserEndpoint.getMyFollowing(page: currentPage, limit: JFConstants.paginationPageLimit)
            
        }
    }
}

class JFPortFolioVC: JFViewController, XMSegmentedControlDelegate {
   
    //MARK:- IBOutlets
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    @IBOutlet weak var subTabsContainerView: UIView!
    
    //MARK:- Private properties
    private weak var actionToEnable : UIAlertAction?

    //MARK:- Public properties
    let followingVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "JFPortFolioSubVC") as! JFPortFolioSubVC
    let myNetworkVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "JFPortFolioSubVC") as! JFPortFolioSubVC
    let discoverVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "JFPortFolioSubVC") as! JFPortFolioSubVC
    
    var direction: AnimationDirection = .rightToLeft
    var previousSelectedTab: SelectedCategory = .following
    
    var selectedVC: JFPortFolioSubVC!
    var invitedVia: InviteMedium = .viaSMS

    //MARK:- Computed properties
    var currentSelectedTab: SelectedCategory = .following {
        didSet {
            
            if previousSelectedTab == currentSelectedTab {
                return
            }
            
            direction = (currentSelectedTab.rawValue > previousSelectedTab.rawValue) ? .rightToLeft : .leftToRight
            
            add(asChildViewController: getSelectedVC(), oldViewController: selectedVC, animated: true, direction: direction)
            selectedVC = getSelectedVC()
            previousSelectedTab = currentSelectedTab
        }
    }
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for portfolio vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configurations()
        add(asChildViewController: followingVC, direction: direction)
        selectedVC = followingVC
    }
    
    //MARK:- User actions
    @IBAction func leftSwiped(_ sender: UISwipeGestureRecognizer) {
        print("Left swiped")
        switch previousSelectedTab {
        case .following:
            segmentedControl.pressTabWithIndex(SelectedCategory.myNetworks.rawValue)
        case .myNetworks:
            segmentedControl.pressTabWithIndex(SelectedCategory.discover.rawValue)
        case .discover:
            break
        }
    }
    
    @IBAction func rightSwiped(_ sender: UISwipeGestureRecognizer) {
        print("right swiped")
        switch previousSelectedTab {
        case .following:
            break
        case .myNetworks:
            segmentedControl.pressTabWithIndex(SelectedCategory.following.rawValue)
        case .discover:
            segmentedControl.pressTabWithIndex(SelectedCategory.myNetworks.rawValue)
        }
    }
    
    //MARK:- Helper methods
    func configurations() {
        configureSegmentedView()
        setupNavigation()
        configureVCs()
    }
    
    func getSelectedVC() -> JFPortFolioSubVC {
        
        var selectedVC: JFPortFolioSubVC!
        
        switch currentSelectedTab {
        case .following: selectedVC = followingVC
        case .myNetworks: selectedVC = myNetworkVC
        case .discover: selectedVC = discoverVC
        }
        
        // Developer's Note:
        // There should be three different view controllers for each category..
        // As of now we are using same View Controller to be allocated three times with selected category configuration
        // So following update added to continue with above approach
        selectedVC.containerUpdatedUserProfile = { [weak self] userProfile in
            self?.updateUsersWithProfile(userProfile: userProfile)
        }
        
        return selectedVC
    }
    
    func updateUsersWithProfile(userProfile: JFProfile) {
        self.followingVC.updateProfile(userProfile: userProfile)
        self.myNetworkVC.updateProfile(userProfile: userProfile)
        self.discoverVC.updateProfile(userProfile: userProfile)
    }
    
    func configureVCs() {
        followingVC.selectedTab = .following
        myNetworkVC.selectedTab = .myNetworks
        discoverVC.selectedTab = .discover
        
        followingVC.expandMyNetworkButtonTapped = { [weak self] in
            self?.segmentedControl.pressTabWithIndex(SelectedCategory.myNetworks.rawValue)
        }
    }
    
    func configureSegmentedView() {
        
        segmentedControl.contentType = .text
        segmentedControl.selectedItemHighlightStyle = .bottomEdge
        segmentedControl.segmentTitle = JFConstants.portfolioTitles
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.highlightTint = .jfDarkGray
        segmentedControl.highlightColor = .jfMediumBrown
        segmentedControl.tint = .lightGray
        segmentedControl.font = UIFont.normal(fontSize: 14.0)
        segmentedControl.delegate = self
        // UI Settings To Be Done By Jawad ^ ~ fixed
    }
    
    func setupNavigation() {
        title = "PORTFOLIO"
        addRightBarButton(withImage: #imageLiteral(resourceName: "search_icon_grey"), text: nil, action: #selector(searchPorfolio))
        addLeftBarButton(withImage: #imageLiteral(resourceName: "profile_icon_with_plus_icon"), text: nil, action: #selector(invitePeople))
    }
   
    @objc func searchPorfolio() {
        let searchVC = getSearchUsersVC()
        
        searchVC.userUpdated = { [weak self] userProfile in
            self?.updateUsersWithProfile(userProfile: userProfile)
        }
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func getInviteUserInfo(via medium: InviteMedium?) {
        guard let inviteMedium = medium else {return}
        let placeholderText = inviteMedium == .viaSMS ? "e.g. (123) 456-7890" : "e.g. john@doe.com"
        self.invitedVia = inviteMedium
        let keyboardType = inviteMedium == .viaSMS ? UIKeyboardType.numberPad : UIKeyboardType.emailAddress
        let alertWithTextField = UIAlertController(title: "\(inviteMedium.inviteHelpText)", message: inviteMedium.inviteMessageHelpText, preferredStyle: .alert)
        
        alertWithTextField.addTextField(text: "", placeholder: placeholderText, editingChangedTarget: self, editingChangedSelector: #selector(inviteTextFieldChanged(_:)), keyboardType: keyboardType)
        alertWithTextField.textFields?.first?.maxLength = inviteMedium == .viaSMS ? 16 : 50
        
        // A cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Canelled")
        }
        
        // This action handles your confirmation action
        let confirmAction = UIAlertAction(title: "Send", style: .default) { _ in
            
            var inputText = alertWithTextField.textFields?.first?.text ?? ""
            
            if inviteMedium == .viaSMS {
                inputText = inputText.extractNumbers()
                inputText = "+\(JFUtility.getCountryCode() ?? "1")" + inputText
            }
            
            self.inviteService(inviteVia: inviteMedium, contactString: inputText, completion: { (success) in
                print("Sent successfully ")
            })
        }
        confirmAction.isEnabled = false
        
        actionToEnable = confirmAction
        
        // Add the actions, the order here does not matter
        alertWithTextField.addAction(cancelAction)
        alertWithTextField.addAction(confirmAction)
        
        tabBarController?.present(alertWithTextField, animated: true, completion: nil)
    }
    
    @objc func invitePeople() {
        JFSendInviteAlertViewController.presentInviteController(fromViewController: tabBarController) { (medium) in
            self.getInviteUserInfo(via: medium)
        }
    }
    
    @objc func inviteTextFieldChanged(_ textField: UITextField) {
        print("invited Text changes \(String(describing: textField.text))")
        
        if invitedVia == .viaSMS {
            textField.text = Validator(withView: UIView()).formatPhoneNumber(textField.text!)
            actionToEnable?.isEnabled = textField.text?.count ?? 0 >= JFConstants.formattedPhoneNumberDigits
        } else {
            actionToEnable?.isEnabled = textField.text?.isValidEmail ?? false
        }
    }
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        currentSelectedTab = SelectedCategory(rawValue: selectedSegment) ?? .following
        print("selectedSegment: \(currentSelectedTab)")
    }

    //MARK:- Pagination
    func addChildVC(newVC: UIViewController, direction: AnimationDirection) {
        switch direction {
        case .rightToLeft:
            newVC.view.frame.origin.x = -subTabsContainerView.frame.width
            
        case .leftToRight:
            newVC.view.frame.origin.x = subTabsContainerView.frame.width
        }
        
        UIView.animate(withDuration: 1.5, animations: {
            newVC.view.frame.origin.x = self.subTabsContainerView.frame.width + self.subTabsContainerView.frame.width
        }, completion: nil)
    }
    
    private func add(asChildViewController viewController: UIViewController, oldViewController: UIViewController? = nil, animated: Bool = true, direction: AnimationDirection) {
        // Add Child View Controller
        addChildViewController(viewController)
        viewController.view.frame = subTabsContainerView.bounds
        
        guard let oldVCFrame = oldViewController?.view.frame else {
            subTabsContainerView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            return
        }
        
        var newVCFrame = viewController.view.frame

        // Setting initial frame of child VC
        let newVCStartXValue = direction == .rightToLeft ? (newVCFrame.origin.x + JFConstants.screenSize.width) : (newVCFrame.origin.x - JFConstants.screenSize.width)
        newVCFrame.origin.x = newVCStartXValue
        viewController.view.frame = newVCFrame
        
        subTabsContainerView.addSubview(viewController.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            oldViewController!.view.frame.origin.x = oldViewController!.view.frame.origin.x + (direction == .rightToLeft ? (oldVCFrame.origin.x - JFConstants.screenSize.width) : (oldVCFrame.origin.x + JFConstants.screenSize.width))
            viewController.view.frame = self.subTabsContainerView.bounds
        }) { (finished) in

            if finished {
                self.remove(asChildViewController: oldViewController)

                // Notify Child View Controller
                viewController.didMove(toParentViewController: self)
            }
        }
        
        // Configure Child View
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.layoutIfNeeded()
    }
    
    private func remove(asChildViewController viewController: UIViewController?) {
        // Notify Child View Controller
        viewController?.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController?.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController?.removeFromParentViewController()
    }
}

//MARK:- Network calls
extension JFPortFolioVC {
    func inviteService(inviteVia: InviteMedium, contactString :String, completion: CompletionBlockWithBool?) {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.invitingUser, animated: true)
        
        let endPoint = inviteVia == .viaSMS ? JFUserEndpoint.inviteViaSMS(phoneNumber: contactString) : JFUserEndpoint.inviteViaEmail(email: contactString)
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            completion?(response.success)
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success { // successfully invited
                MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.tabBarController?.view)!, title: "Invite sent", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                    strongSelf.navigationController?.popViewController(animated: true)
                })
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf) { success in
                    if success {
                        strongSelf.inviteService(inviteVia: inviteVia, contactString: contactString, completion: completion)
                    }
                }
            }
        }
    }
}
