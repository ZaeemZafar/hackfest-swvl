//
//  JFUserEndpoint.swift
//  Hackfest-swvl
//
//  Created by Umair on 13/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum JFUserEndpoint: JFAPIConfig {
    
    case login(email: String, password: String)
    case loginWithFB(facebookId: String)
    case logout
    case delete
    case verifyPassword(password: String)
    case forgotPassword(email: String)
    case emailExists(email: String)
    case phoneNumberExists(phoneNumber: String)
    case resetPassword(code: String, password: String)
    case updateProfile(firstName: String, lastName: String, location: String, bio: String)
    case changePassword(oldPassword: String, newPassword: String)
    case updateEmail(email: String)
    case updatePhoneNumber(phoneNumber: String)
    case signUpUser(userInfo: JFSignUpUser)
    case signUpWithFacebookUser(userInfo: JFSignUpUser)
    case sendTwillioVerificationCode(phoneNumber: String)
    case profile
    case termsAndConditon
    case privacyAndPolicy
    case about
    case uploadS3Image
    case profileImageUpdate(fileName: String)
    case config
    case discover(filter: UserFilter)
    case userProfile(userID: String)
    case contacts(contacts: [String])
    case facebookFriends(facebookIds: [String])
    
    case settings
    case connectWithFacebook(flag: Bool, facebookId: String, fbProfileLink: String)
    case fbLinkVisibility(makeFbLinkVisible: Bool)
    case settingsPrivacy(isCaptainProfile: Bool)
    case settingsToggleRatingsAcceptance(acceptRatings: Bool, acceptAnonymousRatings: Bool, traitAppearance: Bool, traitPersonality: Bool, traitIntelligence: Bool)
    
    case getMyNetwork(page: Int, limit: Int)
    case getMyFollowing(page: Int, limit: Int)
    case followUser(userID: String)
    case unFollowUser(userID: String)
    case cancelFollowRequest(targetUserId: String)
    case acceptFollowRequest(userID: String, requestID: String)
    case declineFollowRequest(requestID: String)
    case notificationFollowListing(page: Int, limit: Int)
    case followCount
    case notificationCount
    
    case block(targetUserId: String)
    case unblock(blockUserId: String)
    case blockList(page: Int, limit: Int)
    
    case rateUser(userId: String, ratingCategory:[CategoryTypes: [Int]], isAnonymous: Bool)
    case requestRating(userId: String)
    
    case inviteViaEmail(email: String)
    case inviteViaSMS(phoneNumber: String)
    
    case updateLocation(longitude: String, latitude: String)
    case userLocationPreference(locationEnabled: Bool)
    case userNotificationPreference(notificationEnabled: Bool)
    
    case notificationsListing(page: Int, limit: Int)
    case notificationsClearAll
    
    case graphUser(userId: String)
    
    case indexDetail
    case ratingsHistory
    
    case updatePushTokenOnServer
    
    var method: HTTPMethod {
        
        switch self {
            
        case .delete:
            return .delete
        case .profile, .logout, .termsAndConditon, .privacyAndPolicy, .config, .about, .discover, .userProfile, .settings, .notificationFollowListing, .followCount, .getMyNetwork, .getMyFollowing, .blockList, .notificationsListing, .graphUser, .indexDetail, .ratingsHistory, .notificationCount:
            return .get
            
        case .login, .signUpUser, .signUpWithFacebookUser, .sendTwillioVerificationCode, .uploadS3Image, .emailExists, .phoneNumberExists, .forgotPassword, .loginWithFB, .followUser, .rateUser, .requestRating, .contacts, .facebookFriends, .inviteViaEmail, .inviteViaSMS, .verifyPassword, .notificationsClearAll:
            return .post
            
        case .userNotificationPreference, .userLocationPreference, .resetPassword, .updateProfile, .changePassword, .updateEmail, .updatePhoneNumber, .profileImageUpdate, .settingsPrivacy,.connectWithFacebook, .fbLinkVisibility, .settingsToggleRatingsAcceptance, .acceptFollowRequest, .cancelFollowRequest, .declineFollowRequest, .unFollowUser, .block, .unblock, .updateLocation, .updatePushTokenOnServer:
            return .put
        }
    }
    
    // MARK: - Path
    
    var path: String {
        
        switch self {
        case .login:
            return "api/users/login"
        case .loginWithFB:
            return "api/users/login/facebook"
        case .logout:
            return "api/users/logout"
        case .delete:
            return "api/users/settings/delete"
        case .verifyPassword:
            return "api/users/settings/verifypassword"
        case .profile:
            return "api/users/profile"
        case .forgotPassword:
            return "api/users/forgotpassword"
        case .resetPassword:
            return "api/users/resetpassword"
        case .updateProfile:
            return "api/users/update"
        case .changePassword:
            return "api/users/changepassword"
        case .updateEmail:
            return "api/users/update/email"
        case .updatePhoneNumber:
            return "api/users/update/phonenumber"
        case .signUpUser:
            return "api/users/signup"
        case .signUpWithFacebookUser:
            return "api/users/signup/facebook"
        case .sendTwillioVerificationCode:
            return "api/twilio/verification"
        case .emailExists:
            return "api/users/emailexists"
        case .phoneNumberExists:
            return "api/users/phonenumberexists"
        case .privacyAndPolicy:
            return "api/general/privacypolicy/html"
        case .termsAndConditon:
            return "api/general/termsandconditions/html"
        case .about:
            return "api/general/aboutus/html"
        case .updateLocation:
            return "api/users/update/location"
        case .userLocationPreference:
            return "api/users/settings/location"
        case .userNotificationPreference:
            return "api/users/settings/notification"
        case .uploadS3Image:
            return "api/upload/s3/profile"
        case .config:
            return "api/configs"
        case .profileImageUpdate:
            return "api/users/profileimage"
        case .discover:
            return "api/network/discover"
        case .userProfile:
            return "api/network/profile"
        case .contacts:
            return "api/network/contacts"
        case .facebookFriends:
            return "api/network/facebookfriends"
            
        case .settings:
            return "api/users/settings"
        case .connectWithFacebook:
            return "api/users/settings/connectwithfacebook"
        case .fbLinkVisibility:
            return "api/users/settings/fblinkvisibility"
        case .settingsPrivacy:
            return "api/users/settings/privacy"
        case .settingsToggleRatingsAcceptance:
            return "api/users/settings/toggleratingsacceptance"
            
            
        case .getMyFollowing:
            return "api/network/friends"
            
        case .getMyNetwork:
            return "api/network"
            
        case .followUser:
            return "api/network/request/makefriend"
            
        case .unFollowUser:
            return "api/network/unfollow"
            
        case .acceptFollowRequest:
            return "api/network/followrequest/accept"
            
        case .cancelFollowRequest:
            return "api/network/followrequest/cancel"
            
        case .declineFollowRequest:
            return "api/network/followrequest/decline"
            
        case .notificationFollowListing:
            return "api/notifications/follow"
            
        case .notificationsListing:
            return "api/notifications"
            
        case .notificationsClearAll:
            return "api/notifications/clear/all"
            
        case .followCount:
            return "api/notifications/follow/count"
            
        case .notificationCount:
            return "api/notifications/unseen/count"
            
            
        case .block:
            return "api/users/settings/block"
        case .unblock:
            return "api/users/settings/unblock"
        case .blockList:
            return "api/users/settings/block/list"
            
            
        case .rateUser:
            return "api/network/rate"
        case .requestRating:
            return "api/network/request/rate"
            
            
        case .inviteViaEmail:
            return "api/invite/email"
        case .inviteViaSMS:
            return "api/invite/sms"
        
        case .graphUser:
            return "api/users/graph/user"
            
        case .indexDetail:
            return "api/users/indexdetail"
        case .ratingsHistory:
            return "api/network/ratings"
        
        case .updatePushTokenOnServer:
            return "api/users/update/devicetoken"
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        
        /*switch self {
         // Add header for any switch case if needed!!!
         
         default:
         return nil
         
         }*/
        return nil
    }
    
    // MARK: - Parameters
    
    var parameters: Parameters? {
        
        switch self {
        case .login(let email, let password):
            var params = [String: Any]()
            
            params["email"] = email
            params["password"] = password
            params["deviceUid"] = JFConstants.uniqueIdentifier
            if JFNotificationManager.shared.fcmPushToken.isEmpty == false {
                params["deviceToken"] = JFNotificationManager.shared.fcmPushToken
            }
            params["deviceType"] = "ios"
            
            return params
        case .loginWithFB(let facebookId):
            var params = [String: Any]()
            
            params["facebookId"] = facebookId
            params["password"] = "aA12345678!" // Developer's Note this is hard coded password for security purposes
            params["deviceUid"] = JFConstants.uniqueIdentifier
            if JFNotificationManager.shared.fcmPushToken.isEmpty == false {
                params["deviceToken"] = JFNotificationManager.shared.fcmPushToken
            }
            params["deviceType"] = "ios"
            
            return params
        case .logout:
            return nil
        case .delete:
            return nil
        case .verifyPassword(let password):
            var params = [String: Any]()
            params["password"] = password
            return params
        case .profile:
            return nil
        case .forgotPassword(let email):
            var params = [String: Any]()
            
            params["email"] = email
            
            return params
        case .resetPassword(let code, let password):
            var params = [String: Any]()
            
            params["code"] = code
            params["password"] = password
            
            return params
        case .updateProfile(let fName, let lName, let location, let bio):
            var params = [String: Any]()
            
            params["firstName"] = fName
            params["lastName"] = lName
            params["location"] = location
            params["biography"] = bio
            
            return params
        case .changePassword(let oldPassword, let newPassword):
            var params = [String: Any]()
            
            params["oldPassword"] = oldPassword
            params["newPassword"] = newPassword
            
            return params
        case .updateEmail(let email):
            var params = [String: Any]()
            
            params["email"] = email
            
            return params
        case .updatePhoneNumber(let phoneNumber):
            var params = [String: Any]()
            
            params["phoneNumber"] = phoneNumber
            
            return params
        case .signUpUser(let userInfo):
            var params = [String: Any]()
            
            params["firstName"] = userInfo.firstName
            params["lastName"] = userInfo.lastName
            params["email"] = userInfo.email
            params["password"] = userInfo.password
            params["phoneNumber"] = userInfo.phoneNumber
            params["image"] = userInfo.image
            params["traitAppearance"] = userInfo.traitAppearance
            params["traitPersonality"] = userInfo.traitPersonality
            params["traitIntelligence"] = userInfo.traitIntelligence
            params["traitNone"] = userInfo.traitNone
            params["notificationsEnabled"] = userInfo.notificationsEnabled
            params["locationEnabled"] = userInfo.locationEnabled
            params["isCaptainProfile"] = userInfo.isCaptainProfile
            params["deviceUid"] = userInfo.deviceUID
            if JFNotificationManager.shared.fcmPushToken.isEmpty == false {
                params["deviceToken"] = JFNotificationManager.shared.fcmPushToken
            }
            params["deviceType"] = userInfo.deviceType
            
            return params
            
        case .signUpWithFacebookUser(let userInfo):
            var params = [String: Any]()
            
            params["facebookId"] = userInfo.facebookID
            params["firstName"] = userInfo.firstName
            params["lastName"] = userInfo.lastName
            params["email"] = userInfo.email
            params["phoneNumber"] = userInfo.phoneNumber
            params["image"] = userInfo.image
            params["traitAppearance"] = userInfo.traitAppearance
            params["traitPersonality"] = userInfo.traitPersonality
            params["traitIntelligence"] = userInfo.traitIntelligence
            params["traitNone"] = userInfo.traitNone
            params["notificationsEnabled"] = userInfo.notificationsEnabled
            params["locationEnabled"] = userInfo.locationEnabled
            params["isCaptainProfile"] = userInfo.isCaptainProfile
            params["fbProfileLink"] = userInfo.facebookProfileLink
            params["deviceUid"] = userInfo.deviceUID
            params["deviceType"] = userInfo.deviceType
            
            if JFNotificationManager.shared.fcmPushToken.isEmpty == false {
                params["deviceToken"] = JFNotificationManager.shared.fcmPushToken
            }
            
            return params
            
        case .sendTwillioVerificationCode(let phoneNumber):
            var params = [String: Any]()
            params["phoneNumber"] = phoneNumber
            
            return params
            
        case .emailExists(let email):
            var params = [String: Any]()
            params["email"] = email
            
            return params
        case .phoneNumberExists(let phonuNumber):
            var params = [String: Any]()
            params["phoneNumber"] = phonuNumber
            
            return params
            
        case .termsAndConditon:
            return nil
        case .privacyAndPolicy:
            return nil
        case .about:
            return nil
            
        case .updateLocation(let longitude, let latitude):
            var params = [String: Any]()
            params["longitude"] = longitude
            params["latitude"] = latitude
            return params
            
            
        case .userLocationPreference(let locationEnabled):
            var params = [String: Any]()
            params["enableLocation"] = NSNumber(value: locationEnabled)
            return params
            
        case .userNotificationPreference(let notificationEnabled):
            var params = [String: Any]()
            params["enableNotification"] = NSNumber(value: notificationEnabled)
            return params
            
        case .uploadS3Image:
            return nil
            
        case .config:
            return nil
            
        case .profileImageUpdate(let fileName):
            var params = [String: Any]()
            params["image"] = fileName
            return params
            
        case .discover(let filter):
            
            return filter.getParams(filter: filter)
            
        case .userProfile(let userID):
            var params = [String: Any]()
            params["userId"] = userID
            return params
            
        case .contacts(let contacts):
            var params = [String: Any]()
            params["contacts"] = contacts
            return params
        case .facebookFriends(let facebookIds):
            var params = [String: Any]()
            params["facebookIds"] = facebookIds
            return params
            
        case .settings:
            return nil
        case .settingsPrivacy(let isCaptainProfile):
            var params = [String: Any]()
            params["isCaptainProfile"] = isCaptainProfile
            return params
        case .connectWithFacebook(let flag, let facebookId, let fbProfileLink):
            var params = [String: Any]()
            params["flag"] = flag
            params["facebookId"] = facebookId
            params["fbProfileLink"] = fbProfileLink
            return params
        case .fbLinkVisibility(let makeFbLinkVisible):
            var params = [String: Any]()
            params["makeFbLinkVisible"] = makeFbLinkVisible
            return params
        case .settingsToggleRatingsAcceptance(let acceptRatings, let acceptAnonymousRatings, let traitAppearance, let traitPersonality, let traitIntelligence):
            var params = [String: Any]()
            params["acceptRatings"] = acceptRatings
            params["acceptAnonymousRatings"] = acceptAnonymousRatings
            params["traitAppearance"] = traitAppearance
            params["traitIntelligence"] = traitIntelligence
            params["traitPersonality"] = traitPersonality
            return params
            
        case .followUser(let userID):
            var params = [String: Any]()
            params["userId"] = userID
            return params
            
        case .unFollowUser(let userID):
            var params = [String: Any]()
            params["userId"] = userID
            return params
            
        case .acceptFollowRequest(let userID, let requestID):
            var params = [String: Any]()
            params["userId"] = userID
            params["requestId"] = requestID
            return params
            
        case .cancelFollowRequest(let targetUserId):
            var params = [String: Any]()
            params["targetUserId"] = targetUserId
            return params
            
        case .declineFollowRequest(let requestID):
            var params = [String: Any]()
            params["requestId"] = requestID
            return params
            
        case .notificationFollowListing(let page, let limit):
            var params = [String: Any]()
            params["page"] = page
            params["limit"] = limit
            return params
            
        case .notificationsListing(let page, let limit):
            var params = [String: Any]()
            params["page"] = page
            params["limit"] = limit
            return params
            
        case .notificationsClearAll:
            return nil
            
        case .getMyNetwork(let page, let limit):
            var params = [String: Any]()
            params["page"] = page
            params["limit"] = limit
            return params
            
        case .getMyFollowing(let page, let limit):
            var params = [String: Any]()
            params["page"] = page
            params["limit"] = limit
            return params
            
        case .followCount:
            return nil
        
        case .notificationCount:
            return nil
            
        case .block(let targetUserId):
            var params = [String: Any]()
            params["targetUserId"] = targetUserId
            return params
        case .unblock(let blockUserId):
            var params = [String: Any]()
            params["reportUserId"] = blockUserId
            return params
        case .blockList(let page, let limit):
            var params = [String: Any]()
            params["page"] = page
            params["limit"] = limit
            return params
            
        case .rateUser(let userID, let ratingCategory, let isAnonymous):
            var params = [String: Any]()
            
            params["userId"] = userID
            
            // Developer's Note: '+1' is for consider indexpath in category table view: /JW/ We should use enum approach
            // TODO:
            let appearanceValues = ratingCategory[.appearance] ?? [Int]()
            let intelligenceValues = ratingCategory[.intelligence] ?? [Int]()
            let personalityValues = ratingCategory[.personality] ?? [Int]()
            
            params["traitAppearance"] = appearanceValues
            params["traitIntelligence"] = intelligenceValues
            params["traitPersonality"] = personalityValues
            
            params["isAnonymous"] = isAnonymous
            return params
            
        case .requestRating(let userId):
            var params = [String: Any]()
            params["userId"] = userId
            return params
            
        case .inviteViaEmail(let email):
            var params = [String: Any]()
            params["email"] = email
            return params
        case .inviteViaSMS(let phoneNumber):
            var params = [String: Any]()
            params["phoneNumber"] = phoneNumber
            return params
            
        case .graphUser(let userId):
            var params = [String: Any]()
            params["userId"] = userId
            return params
        case .indexDetail:
            return nil
        case .ratingsHistory:
            return nil
            
        case .updatePushTokenOnServer:
            var params = [String: Any]()
            if JFNotificationManager.shared.fcmPushToken.isEmpty == false {
                params["deviceToken"] = JFNotificationManager.shared.fcmPushToken
            }
            
            return params
        }
    }
    
    var setAuth: Bool {
        
        switch self {
        case .updateProfile, .updatePhoneNumber, .updateEmail, .changePassword, .logout, .delete, .verifyPassword, .profile, .userLocationPreference, .userNotificationPreference, .profileImageUpdate, .discover, .userProfile, .settings, .settingsPrivacy, .connectWithFacebook, .fbLinkVisibility, .settingsToggleRatingsAcceptance, .followUser, .unFollowUser,.acceptFollowRequest, .cancelFollowRequest, .declineFollowRequest, .notificationFollowListing, .followCount, .getMyNetwork, .getMyFollowing, .block, .unblock, .blockList, .contacts, .facebookFriends, .rateUser, .requestRating, .notificationsListing, .notificationsClearAll, .inviteViaEmail, .inviteViaSMS, .updateLocation, .graphUser, .indexDetail, .ratingsHistory, .updatePushTokenOnServer, .notificationCount:
            return true
            
        default:
            return false
        }
    }
}

