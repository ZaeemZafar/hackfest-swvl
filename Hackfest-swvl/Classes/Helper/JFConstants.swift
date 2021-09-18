//
//  JFConstants.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit

// MARK:- App Target

// How To Use : JFAppTarget.current.serverBasePath()
enum JFAppTarget: Int {
    case development = 0
    case qa
    case staging
    case appStore
    
    static var current: JFAppTarget {
        
        #if APPSTORE
            return JFAppTarget.appStore
            
        #elseif STAGING
            return JFAppTarget.staging
            
        #elseif QA
            return JFAppTarget.qa
            
        #else
            return JFAppTarget.development
            
        #endif
    }
    
    func serverBasePath() -> String {
        
        switch self {
            
        case .development:
            return "http://dev.justfamous.com:4000/"
            
        case .qa:
            return "http://dev.justfamous.com:4001/"
            
        case .staging:
            return "http://dev.justfamous.com:4002/"
            
        case .appStore:
            return "https://api.justfamous.com/"
        }
    }
    
    var secondsLimitForNextOperation: TimeInterval {
        switch self {
        case .development, .qa:
            return 2
        default:
            return 59 * 60
        }
    }
    
    var pageLimitForNextOperation: Int {
        switch self {
        case .development, .qa:
            return 12
        default:
            return 25
        }
    }
    
    var googleFirebaseIdentifier: String {
        
        switch self {
        case .development:
            return "GoogleService-Info_dev"
            
        case .qa:
            return "GoogleService-Info_qa"
            
        case .staging:
            return "GoogleService-Info_staging"
            
        case .appStore:
            return "GoogleService-Info_appStore"
        }
    }
}

enum SelectedLocation: Int {
    case miNone = 0
    case mi25 = 25
    case mi50 = 50
    case mi100 = 100
    case mi500 = 500
}

enum SortFilter: Int {
    case highestToLowest = 0, lowestToHighest, aToZ, zToA, none
    
    var stringValue: String {
        switch self {
        case .highestToLowest:
            return "indexDescending"
        case .lowestToHighest:
            return "indexAscending"
        case .zToA:
            return "alphabaticalDescending"
        case .aToZ:
            return "alphabaticalAscending"
        case .none:
            return ""
        }
    }
    
    var getHeaderText: String? {
        switch self {
        case .highestToLowest:
            return "Sorted by JF Index: Highest - Lowest"
        case .lowestToHighest:
            return "Sorted by JF Index: Lowest - Highest"
        case .aToZ:
            return "Sorted by Alphabetical: A - Z"
        case .zToA:
            return "Sorted by Alphabetical: Z - A"
        default:
            return nil
        }
    }
}

enum Trait: Int, Codable, CaseIterable {
    case friendly = 0, dressing, iqLevel, communication, personality, behavior, cleanliness, punctuality, appearance, none
    
    var stringValue: String {
        switch self {
        case .friendly: return "friendly"
        case .dressing: return "dressing"
        case .iqLevel: return "iqLevel"
        case .communication: return "communication"
        case .personality: return "personality"
        case .behavior: return "behavior"
        case .cleanliness: return "cleanliness"
        case .punctuality: return "punctuality"
        case .appearance: return "appearance"
        case .none: return "none"
        }
    }
    
    var icon: UIImage {
        return UIImage()
//        switch self {
//        case .friendly: return "friendly"
//        case .dressing: return "dressing"
//        case .iqLevel: return "iqLevel"
//        case .communication: return "communication"
//        case .personality: return "personality"
//        case .behavior: return "behavior"
//        case .cleanliness: return "cleanliness"
//        case .punctuality: return "punctuality"
//        case .appearance: return "appearance"
//        case .none: return "none"
//        }
    }
    
    var categoryType: CategoryTypes {
        switch self {
        case .friendly: return .friendly
        case .dressing: return .dressing
        case .iqLevel: return .iqLevel
        case .communication: return .communication
        case .personality: return .personality
        case .behavior: return .behavior
        case .cleanliness: return .cleanliness
        case .punctuality: return .punctuality
        case .appearance: return .appearance
        default:
            return .appearance
        }
    }
    
    var typeDataSource: MyProfileTableDataSourceEnum {
        switch self {
        case .friendly: return .friendly
        case .dressing: return .dressing
        case .iqLevel: return .iqLevel
        case .communication: return .communication
        case .personality: return .personality
        case .behavior: return .behavior
        case .cleanliness: return .cleanliness
        case .punctuality: return .punctuality
        case .appearance: return .appearance
        default:
            return .appearance
        }
    }
    
    var indexMultiplierType: JFIndexMultiplierType {
        switch self {
        
        case .friendly: return .friendly
        case .dressing: return .dressing
        case .iqLevel: return .iqLevel
        case .communication: return .communication
        case .personality: return .personality
        case .behavior: return .behavior
        case .cleanliness: return .cleanliness
        case .punctuality: return .punctuality
        case .appearance: return .appearance
        default:
            return JFIndexMultiplierType.jfIndex
        }
    }
    
}

enum ProfilePrivacyLevel: String, Codable {
    case publicProfile, privateProfile
}

// MARK:- Service call

struct JFServerRequestPath {
    static let sample = "sample"
}

// MARK:- Alert Constants

struct JFLocalizableConstants {
    static let AlertTitle = "Hackfest-swvl"
    static let OKTitle = NSLocalizedString("OK", comment: "")
    static let OKAYTitle = NSLocalizedString("OKAY", comment: "")
    static let SaveTitle = NSLocalizedString("Save", comment: "")
    static let CancelTitle = NSLocalizedString("Cancel", comment: "")
    static let YesTitle = NSLocalizedString("Yes", comment: "")
    static let NoTitle = NSLocalizedString("No", comment: "")
    static let ConfirmationTitle = NSLocalizedString("Confirmation", comment: "")
    static let DiscardTitle = NSLocalizedString("Discard", comment: "")
    static let UnsavedChanges = NSLocalizedString("You have some unsaved changes!\nDo you want to save the changes?", comment: "")
    static let ClearAll = NSLocalizedString("Clear All", comment: "")
    
    static let NetworkError = NSLocalizedString("Please check your internet connection and try again.", comment: "")
    
    static let EditProfile = NSLocalizedString("EDIT PROFILE", comment: "")
    
    static let RetryTitle = NSLocalizedString("Retry", comment: "")
    static let FacebookError = NSLocalizedString("Error occured while getting Facebook account info", comment: "")
    
    static let BlockConfirmationMessage1 = "They won't be able to see your profile details, index scores, or rate you on Hackfest-swvl."
    
    static let BlockConfirmationMessage2 = "You can unblock them anytime from their profile."
    
    static let UnBlockConfirmationMessage1 = "They will be able to follow you on Hackfest-swvl."
    
    static let UnBlockConfirmationMessage2 = "You can block them anytime from their profile."
}

//MARK:- Categories

struct JFSelectedCategory {
    static let colorArray = [UIColor.jfChooseWordsGreen.withAlphaComponent(0.75), UIColor.jfChooseWordsGreen.withAlphaComponent(0.75), UIColor.jfChooseWordsGreen.withAlphaComponent(0.75), UIColor.jfChooseWordsGreen.withAlphaComponent(0.40), UIColor.jfChooseWordsGreen.withAlphaComponent(0.40), UIColor.jfChooseWordsGreen.withAlphaComponent(0.40), UIColor.jfChooseWordsGreen.withAlphaComponent(0.15), UIColor.jfChooseWordsGreen.withAlphaComponent(0.15), UIColor.jfChooseWordsGreen.withAlphaComponent(0.15), UIColor.jfChooseWordsLightWhite.withAlphaComponent(1.0), UIColor.white.withAlphaComponent(1.0), UIColor.jfChooseWordsLightWhite.withAlphaComponent(1.0), UIColor.jfChooseWordsRed.withAlphaComponent(0.15), UIColor.jfChooseWordsRed.withAlphaComponent(0.15), UIColor.jfChooseWordsRed.withAlphaComponent(0.15), UIColor.jfChooseWordsRed.withAlphaComponent(0.40), UIColor.jfChooseWordsRed.withAlphaComponent(0.40), UIColor.jfChooseWordsRed.withAlphaComponent(0.40), UIColor.jfChooseWordsRed.withAlphaComponent(0.75), UIColor.jfChooseWordsRed.withAlphaComponent(0.75), UIColor.jfChooseWordsRed.withAlphaComponent(0.75), ]
}

//MARK:- Rating category words

struct JFCategoryWords {
    
    static let wordsScoreAtIndex = [-1, 0, 1, 2]
    
    static let words = ["Bad", "Average", "Good", "Excellent"]
}

// MARK:- Loading Titles

struct JFLoadingTitles {
    static let wait = NSLocalizedString("Please wait...", comment: "")
    static let uploadingPhoto = NSLocalizedString("Uploading photo...", comment: "")
    static let sendingVerificationCode = NSLocalizedString("Sending verification code...", comment: "")
    static let signingUp = NSLocalizedString("Signing up...", comment: "")
    static let sendingCode = NSLocalizedString("Sending code...", comment: "")
    static let gettingFBInfo = NSLocalizedString("Getting Facebook info...", comment: "")
    static let loggingIn = NSLocalizedString("Logging in...", comment: "")
    static let loggingOut = NSLocalizedString("Logging out...", comment: "")
    static let deletingAccount = NSLocalizedString("Deleting account...", comment: "")
    static let verifyingPassword = NSLocalizedString("Verifying password...", comment: "")
    static let sendingEmail = NSLocalizedString("Sending email...", comment: "")
    static let updatingProfile = NSLocalizedString("Updating profile...", comment: "")
    static let updatingPassword = NSLocalizedString("Updating password...", comment: "")
    static let updatingEmail = NSLocalizedString("Updating email...", comment: "")
    static let updatingPhoneNumber = NSLocalizedString("Updating phone number...", comment: "")
    static let verifyingCode = NSLocalizedString("Verifying code...", comment: "")
    static let loadingProfile = NSLocalizedString("Loading profile...", comment: "")
    static let loadingProtfolio = NSLocalizedString("Loading portfolio...", comment: "")
    static let loadingSettings = NSLocalizedString("Loading settings...", comment: "")
    static let settingPrivacy = NSLocalizedString("Setting privacy...", comment: "")
    static let deleteRequest = NSLocalizedString("Deleting request...", comment: "")
    static let confirmingRequest = NSLocalizedString("Confirming request...", comment: "")
    static let loadingNotifications = NSLocalizedString("Loading notifications...", comment: "")
    static let updatingPreference = NSLocalizedString("Updating preferences...", comment: "")
    static let settingRatings = NSLocalizedString("Setting ratings...", comment: "")
    
    static let blockingUser = NSLocalizedString("Blocking...", comment: "")
    static let unblockingUser = NSLocalizedString("Unblocking...", comment: "")
    
    static let gettingContacts = NSLocalizedString("Getting contacts...", comment: "")
    static let gettingFacebookFriends = NSLocalizedString("Getting facebook friends...", comment: "")
    static let invitingUser = NSLocalizedString("Inviting...", comment: "")
    
    static let loadingNetworkData = NSLocalizedString("Loading network...", comment: "")
    static let loadingFollowing = NSLocalizedString("Loading following...", comment: "")
    static let loadingDiscoverData = NSLocalizedString("Loading discover...", comment: "")
    
    static let sendingFollowingRequest = NSLocalizedString("Following request...", comment: "")
    static let sendingUnFollowingRequest = NSLocalizedString("Stop following...", comment: "")
    static let sendingCancellingRequest = NSLocalizedString("Cancelling request...", comment: "")
    
    static let loadingUsers = NSLocalizedString("Loading users...", comment: "")
    static let searchingUsers = NSLocalizedString("Searching users...", comment: "")
    static let ratingUser = NSLocalizedString("Rating user...", comment: "")
}


enum CustomURLSchemePath: String {
    case resetPassword = "resetpassword"
    case updateEmail = "updateemail"
    case none = ""
}

enum FAQDataConstants: String {
    case fileName = "FAQ_Data"
    case opened = "opened"
    case showBullets = "showBullets"
    case title = "title"
    case description = "description"
}

// MARK:- Constants Class
class JFConstants: NSObject {
    open static var facebookDisabled: Bool = true
    static let servicesGenericErrorMessage = NSLocalizedString("Invalid response", comment: "")
    static let uniqueIdentifier = UIDevice.current.identifierForVendor!.uuidString
    //static let resetPassworURLScheme = "Hackfest-swvlResetPassword"
    static let resetPassworURLScheme = "Hackfest-swvl://Hackfest-swvl.com/resetpassword?"
    static let uploadImageWidth: CGFloat = 105
    static let jvfURLSchemeHost = "Hackfest-swvl.com"

    static let aboutHackfestswvlLink = "\(JFAppTarget.current.serverBasePath())api/general/aboutus/html"
    static let privacyPolicyLink = "\(JFAppTarget.current.serverBasePath())api/general/privacypolicy/html"
    static let termAndConditionsLink = "\(JFAppTarget.current.serverBasePath())api/general/termsandconditions/html"
    
    // Reference device is iPhone 6 for storyboards and other view sizes
    static let referenceScreenSize = CGRect(x: 0, y: 0, width: 375, height: 667)
    static let screenSize: CGRect = UIScreen.main.bounds
    static let scaledScreenWidth: CGFloat = JFConstants.screenSize.width / JFConstants.referenceScreenSize.width
    static let scaledScreenHeight: CGFloat = JFConstants.screenSize.height / JFConstants.referenceScreenSize.height
    
    static let paginationPageLimit = JFAppTarget.current.pageLimitForNextOperation
    static let minPhoneNumberDigits = 10
    static let formattedPhoneNumberDigits = 16
    static let maximumRating = 20
    static let portfolioTitles = [
        "Following", "My Network", "Discover"
    ]
    
    struct JFUserDefaults {
        static let launchedBefore = "launchedBefore"
        static let s3URL = "s3URL"
        static let s3URLThumbnail = "s3URLThumbnail"
        static let droarLocationEnabled = "droarLocationEnabled"
        static let droarMultiplierEnabled = "droarMultiplierEnabled"
    }
    
    struct Storyboards {
        static let userRegistration = UIStoryboard(name: "UserRegistration", bundle: nil)
    }
    
    struct publishableKeys {
        static let instabugToken = "7ab962f3296c9b8af624eb94117288bf"
    }
    
    struct Notifications {
        static let emailUpdated = NSNotification.Name("emailUpdated")
        static let push = NSNotification.Name("push")
        static let logout = Notification.Name(rawValue: "logOut")
    }
    
    // Developer's Note: Please update S3 bucket URL with better approach: Assigned to Jawad
    
//    class func s3ImageURL(thumbnailImage: Bool) -> String {
//        return "\(JFAppTarget.current.serverBasePath())profile/\(thumbnailImage ? "thumbnail" : "image")/"
//    }
    
    static var s3ImageURL: String {
        get {
            return UserDefaults.standard.value(forKey: JFConstants.JFUserDefaults.s3URL) as? String ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: JFConstants.JFUserDefaults.s3URL)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var s3ThumbnailImageURL: String {
        get {
            return UserDefaults.standard.value(forKey: JFConstants.JFUserDefaults.s3URLThumbnail) as? String ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: JFConstants.JFUserDefaults.s3URLThumbnail)
            UserDefaults.standard.synchronize()
        }
    }
}

#if swift(>=4.2)
#else
public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
#endif
