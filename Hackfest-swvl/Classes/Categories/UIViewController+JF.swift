//
//  UIViewController+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension UIViewController {
    
    func showMailComposeView(subject: String, body: String, isHTML: Bool, toRecipients: [String]?) {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            mailComposeVC.setToRecipients(toRecipients)
            mailComposeVC.setSubject(subject)
            mailComposeVC.setMessageBody(body, isHTML: isHTML)
            
            present(mailComposeVC, animated: true, completion: {
                mailComposeVC.setNeedsStatusBarAppearanceUpdate()
                mailComposeVC.modalPresentationCapturesStatusBarAppearance = true
            })
            
            
        } else {
            print("Cannot send email")
        }
    }
    
    func openMailComposerWithJFDefaultFormat(toEmail email: String = "support@justfamous.com") {
        let device = UIDevice.modelName
        let iosVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.appVersion
        
        var bodyMessage = "\nEmail: " + (JFSession.shared.myProfile?.email ?? "")
        bodyMessage += "\nDevice: " + device + "\niOS version: " + iosVersion + "\nApp version: " + appVersion
        
        showMailComposeView(subject: "", body: bodyMessage, isHTML: false, toRecipients: [email])
    }
    
    func systemCanSendEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func addLeftBarButton(withImage image: UIImage?, text: String?, action: Selector?) {
        let barButton = UIBarButtonItem(title: text, style: .plain, target: self, action: action)
        barButton.image = image
        barButton.fontsSettings()
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addRightBarButton(withImage image: UIImage?, text: String?, action: Selector?) {
        let barButton = UIBarButtonItem(title: text, style: .plain, target: self, action: action)
        barButton.image = image
        barButton.fontsSettings()
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //Storyboard -> Registration
    class func getLandingVC() -> JFLandingViewController {
        let landingVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFLandingViewController") as! JFLandingViewController
        return landingVC
    }
    
    func getLandingVC() -> JFLandingViewController {
        let landingVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFLandingViewController") as! JFLandingViewController
        return landingVC
    }
    
    func getTutorialVC() -> JFTutorialViewController {
        let tutorialVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFTutorialViewController") as! JFTutorialViewController
        return tutorialVC
    }
    
    class func getSocialLoginVC() -> JFSocialLoginViewController {
        let socialLoginVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFSocialLoginViewController") as! JFSocialLoginViewController
        return socialLoginVC
    }
    
    func getSocialLoginVC() -> JFSocialLoginViewController {
        let socialLoginVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFSocialLoginViewController") as! JFSocialLoginViewController
        return socialLoginVC
    }
    
    func getSocialSignUpVC() -> JFSocialSignUpViewController {
        let socialSignUpVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFSocialSignUpViewController") as! JFSocialSignUpViewController
        return socialSignUpVC
    }
    
    func getSignUpEmailVC() -> JFSignUpEmailViewController {
        let signupEmailVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFSignUpEmailViewController") as! JFSignUpEmailViewController
        return signupEmailVC
    }
    
    func getLoginEmailVC() -> JFLoginViewController {
        let jfLoginVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFLoginViewController") as! JFLoginViewController
        return jfLoginVC
    }
    
    func getSignUpFacebookVC() -> JFSignUpFacebookViewController {
        let signUpFacebookVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFSignUpFacebookViewController") as! JFSignUpFacebookViewController
        return signUpFacebookVC
    }
    
    func getVerificationVC() -> JFVerificationViewController {
        let verificationVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFVerificationViewController") as! JFVerificationViewController
        return verificationVC
    }
    
    func getEnterCodeVC() -> JFEnterCodeViewController {
        let enterCodeVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFEnterCodeViewController") as! JFEnterCodeViewController
        return enterCodeVC
    }
    
    func getChooseCategoriesVC() -> JFChooseCategoriesViewController {
        let chooseCategoriesVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFChooseCategoriesViewController") as! JFChooseCategoriesViewController
        return chooseCategoriesVC
    }
    
    func getPrivacySettingsVC() -> JFPrivacySettingsViewController {
        let privacySettingsVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFPrivacySettingsViewController") as! JFPrivacySettingsViewController
        return privacySettingsVC
    }
    
    func getNotificationAccessVC() -> JFNotificationAccessViewController {
        let notificationAccessVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFNotificationAccessViewController") as! JFNotificationAccessViewController
        return notificationAccessVC
    }
    
    func getLocationAccessVC() -> JFLocationAccessViewController {
        let locationAccessVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFLocationAccessViewController") as! JFLocationAccessViewController
        return locationAccessVC
    }
    
    func getTermsAndPrivacyVC() -> JFTermsAndPrivacyViewController {
        let termsAndPrivacyVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFTermsAndPrivacyViewController") as! JFTermsAndPrivacyViewController
        return termsAndPrivacyVC
    }
    
    //Storyboard -> Profile
    class func getTabbarVC() -> UITabBarController {
        let tabbarVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "DashboardTabBar") as! UITabBarController
        return tabbarVC
    }
    
    func getTabbarVC() -> JFTabbarViewController {
        let tabbarVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "DashboardTabBar") as! JFTabbarViewController
        return tabbarVC
    }
    
    func getEditProfileVC() -> JFEditProfileViewController {
        let editProfileVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFEditProfileViewController") as! JFEditProfileViewController
        return editProfileVC
    }
    
    func getChangePhoneEnterCodeVC() -> JFChangePhoneEnterCodeViewController {
        let changePhoneEnterCodeVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFChangePhoneEnterCodeViewController") as! JFChangePhoneEnterCodeViewController
        return changePhoneEnterCodeVC
    }
    
    func getChangePasswordVC() -> JFChangePasswordViewController {
        let changePasswordVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFChangePasswordViewController") as! JFChangePasswordViewController
        return changePasswordVC
    }
    
    func getChangeEmailVC() -> JFChangeEmailViewController {
        let changeEmailVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFChangeEmailViewController") as! JFChangeEmailViewController
        return changeEmailVC
    }
    
    func getChangePhoneVC() -> JFChangePhoneViewController {
        let changePhoneVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFChangePhoneViewController") as! JFChangePhoneViewController
        return changePhoneVC
    }
    
    func getNotificationsVC() -> JFNotificationsViewController {
        let vc = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFNotificationsViewController") as! JFNotificationsViewController
        return vc
    }
    
    func getFollowRequestNotificationVC() -> JFFollowRequestViewController {
        let vc = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFFollowRequestViewController") as! JFFollowRequestViewController
        return vc
    }
    
    func getRatingCategoryVC() -> JFChooseCategoryViewController {
        let getRateCategoryVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFChooseCategoryViewController") as! JFChooseCategoryViewController
        return getRateCategoryVC
    }
    
    func getRatingCategoryChooseWordsVC() -> JFChooseCategoryWordsViewController {
        let vc = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFChooseCategoryWordsViewController") as! JFChooseCategoryWordsViewController
        return vc
    }
    
    func getShowNameOrAnonymousVC() -> JFShowNameOrAnonymousViewController {
        let vc = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFShowNameOrAnonymousViewController") as! JFShowNameOrAnonymousViewController
        return vc
    }
    
    func getRatingSubmittedVC() -> JFRatingSubmittedViewController {
        let vc = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFRatingSubmittedViewController") as! JFRatingSubmittedViewController
        return vc
    }
    
    func getSubmitRattingChoiceVC() -> JFSubmitRattingChoiceViewController {
        let vc = UIStoryboard.profile.instantiateViewController(withIdentifier: "JFSubmitRattingChoiceViewController") as! JFSubmitRattingChoiceViewController
        return vc
    }
    
    
    //Storyboard -> Portfolio
    func getConnectVC() -> ConnectViewController {
        let connectVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "ConnectViewController") as! ConnectViewController
        return connectVC
    }
    
    func getSearchUsersVC() -> JFSearchUsersViewController {
        let searchUserVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "JFSearchUsersViewController") as! JFSearchUsersViewController
        return searchUserVC
    }
    
    func getFacebookFriendsVC() -> FacebookFriendsViewController {
        let facbookFriendVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "FacebookFriendsViewController") as! FacebookFriendsViewController
        return facbookFriendVC
    }
    
    func getContactsVC() -> ContactsViewController {
        let contactsVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        return contactsVC
    }
    
    func getUserProfileVC() -> JFUserProfileViewController {
        let userProfileVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "JFUserProfileViewController") as! JFUserProfileViewController
        return userProfileVC
    }
    
    func getInviteContactVC() -> InviteContactsViewController {
        let getInviteContactVC = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "InviteContactsViewController") as! InviteContactsViewController
        return getInviteContactVC
    }
    
    func getRefineResultsVC() -> JFRefineResultsViewController {
        let vc = UIStoryboard.portfolio.instantiateViewController(withIdentifier: "JFRefineResultsViewController") as! JFRefineResultsViewController
        return vc
    }
    //Storyboard -> Settings
    func getProfilePrivacyVC() -> JFProfilePrivacyViewController {
        let profilePrivacyVC = UIStoryboard.settings.instantiateViewController(withIdentifier: "JFProfilePrivacyViewController") as! JFProfilePrivacyViewController
        return profilePrivacyVC
    }
    
    func getBlockedUsersVC() -> JFBlockedUsersViewController {
        let blockedUsersVC = UIStoryboard.settings.instantiateViewController(withIdentifier: "JFBlockedUsersViewController") as! JFBlockedUsersViewController
        return blockedUsersVC
    }
    
    func getRatingUsersVC() -> JFRatingViewController {
        let ratingVC = UIStoryboard.settings.instantiateViewController(withIdentifier: "JFRatingViewController") as! JFRatingViewController
        return ratingVC
    }
    
    func getFAQAndHelpVC() -> JFFAQAndHelpViewController {
        let faqAndHelpVC = UIStoryboard.settings.instantiateViewController(withIdentifier: "JFFAQAndHelpViewController") as! JFFAQAndHelpViewController
        return faqAndHelpVC
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Storyboard -> CustomViews
    class func getAlertVC() -> JFAlertViewController {
        let alertVC = UIStoryboard.customViews.instantiateViewController(withIdentifier: "JFAlertViewController") as! JFAlertViewController
        return alertVC
    }
    
    class func getSendInviteAlertVC() -> JFSendInviteAlertViewController {
        let sendInviteAlertVC = UIStoryboard.customViews.instantiateViewController(withIdentifier: "JFSendInviteAlertViewController") as! JFSendInviteAlertViewController
        return sendInviteAlertVC
    }
    
    func getMultiplierVC() -> JFMultiplierViewController {
        let multiplierVC = UIStoryboard.customViews.instantiateViewController(withIdentifier: "JFMultiplierViewController") as! JFMultiplierViewController
        return multiplierVC
    }
    func getRatingsHistoryVC() -> JFRatingsHistoryViewController {
        let ratingsHistoryVC = UIStoryboard.customViews.instantiateViewController(withIdentifier: "JFRatingsHistoryViewController") as! JFRatingsHistoryViewController
        return ratingsHistoryVC
    }
    
    public var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
            
        case .cancelled:
            print("Mail cancelled")
            
        case .saved:
            print("Mail saved")
            
        case .sent:
            print("Mail sent")
            
        case .failed:
            print("Mail sent failure: %@", [error!.localizedDescription])
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIBarButtonItem {
    func fontsSettings() {
        let arr = [NSAttributedStringKey.foregroundColor: UIColor.jfLightGray,
                   NSAttributedStringKey.font: UIFont.normal(fontSize: 14.0)]
        setTitleTextAttributes(arr, for: .highlighted)
        setTitleTextAttributes(arr, for: .disabled)
        setTitleTextAttributes(arr, for: .selected)
        setTitleTextAttributes(arr, for: .focused)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.jfDarkGray,
                                NSAttributedStringKey.font: UIFont.normal(fontSize: 14.0)], for: .normal)
    }
}
