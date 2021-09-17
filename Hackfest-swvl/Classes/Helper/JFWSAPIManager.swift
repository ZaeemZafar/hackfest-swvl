//
//  JFWSAPIManager.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
class JFWepAPIResponse<T: Codable>: Codable {
    var success = false
    var message = JFConstants.servicesGenericErrorMessage
    var serverStatusCode = JFServerResponseCode.validResponse
    var hasInternetAccess = false
    var data: T?
    
    init(success_status: Bool, messageString: String, dataModel: T?) {
        success = success_status
        message = messageString
        data = dataModel
    }
}

enum NotificationCountType {
    case followNotification, pushNotification
}

class GenericResponse: Codable {
    
}

class JFWSAPIManager: NSObject {
    
    // MARK: -
    
    static let shared: JFWSAPIManager = {
        let instance = JFWSAPIManager()
        
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    // MARK: -
    
    func loginWithEmail(email: String, password: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.login(email: email, password: password)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    // For now we are not parsing the user object
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func logout(completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.logout
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    // For now we are not parsing the user object
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func loginWithFacebook(facebookId: String, completion: @escaping (_ success: Bool, _ userNotExist: Bool,_ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.loginWithFB(facebookId: facebookId)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    // For now we are not parsing the user object
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                
                if response.serverStatusCode == 105 {
                    completion(false, true, errorMessage)
                    
                } else {
                    completion(false, false, errorMessage)
                }
                
            } else {
                completion(true, false, "")
            }
        }
    }
    
    func forgotPassword(email: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.forgotPassword(email: email)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func resetPassword(code: String, password: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.resetPassword(code: code, password: password)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func sendJFAPIRequest<T>(apiConfig: JFAPIConfig, completion:@escaping (_ apiResponse: JFWepAPIResponse<T>)->()) {
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var responseMessageString = JFConstants.servicesGenericErrorMessage
            let apiResponse = JFWepAPIResponse<T>(success_status: true, messageString: "", dataModel: nil)
            if response.status {
                responseMessageString = response.message
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue {
                    
                } else if response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    apiResponse.serverStatusCode = .notFound
                }
                
            } else {
                responseMessageString = response.customErrorMessage()
            }
            
            apiResponse.success = !hasError
            apiResponse.message = responseMessageString
            
            apiResponse.hasInternetAccess = JFServerManager.isConnectedToInternet
            
            let jsonDecoder = JSONDecoder()
            
            do {
                if let responseData = response.response?.data {
                    apiResponse.data = try jsonDecoder.decode(T.self, from: responseData)
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
            completion(apiResponse)
        }
    }
    
    func updateProfile(firstName: String, lastName: String, location: String, bio: String,  completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.updateProfile(firstName: firstName, lastName: lastName, location: location, bio: bio)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func updateEmail(email: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.updateEmail(email: email)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func updatePhoneNumber(phoneNumber: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.updatePhoneNumber(phoneNumber: phoneNumber)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func checkEmailExists(email: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.emailExists(email: email)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                if let dict = response.result as? [String: Any] {
                    
                    let emailExists = dict["isExists"] as? Bool ?? false
                    
                    if emailExists == true {
                        completion(false, "Email already exists.")
                        
                    } else {
                        completion(true, "")
                    }
                    
                    
                } else {
                    completion(true, "")
                }
            }
        }
    }
    
    func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.phoneNumberExists(phoneNumber: phoneNumber)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                if let dict = response.result as? [String: Any] {
                    
                    let phoneNumberExists = dict["isExists"] as? Bool ?? false
                    
                    if phoneNumberExists == true {
                        completion(false, "Phone number already exists.")
                        
                    } else {
                        completion(true, "")
                    }
                    
                    
                } else {
                    completion(true, "")
                }
            }
        }
    }
    
    func signUpWithInfo(userInfo: JFSignUpUser,  completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.signUpUser(userInfo: userInfo)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                }
                
                errorMessage = response.message
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    
    func signUpFacebookWithInfo(userInfo: JFSignUpUser,  completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.signUpWithFacebookUser(userInfo: userInfo)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                }
                
                errorMessage = response.message
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    
    func sendTwillioVerificationCode(phoneNumber: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ code: String) -> Void) {
        let apiConfig = JFUserEndpoint.sendTwillioVerificationCode(phoneNumber: phoneNumber)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.alreadyExists.rawValue {
                    errorMessage = response.message
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage, "")
                
            } else {
                if let dict = response.result as? [String: Any] {
                    completion(true, "", dict["verificationCode"] as? String ?? "")
                    
                } else {
                    completion(true, "", "")
                }
            }
        }
    }
    
    func getNotificationCount(forType countType: NotificationCountType, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ count: Int) -> Void) {
        let apiConfig = countType == .followNotification ? JFUserEndpoint.followCount : JFUserEndpoint.notificationCount
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.alreadyExists.rawValue {
                    errorMessage = response.message
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage, 0)
                
            } else {
                if let dict = response.result as? [String: Any] {
                    completion(true, "", dict["count"] as? Int ?? 0)
                    
                } else {
                    completion(true, "", 0)
                }
            }
        }
    }
    
    
    func updateLocationPreference(locationEnabled: Bool, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.userLocationPreference(locationEnabled: locationEnabled)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    // For now we are not parsing the user object
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func updateNotificationPreference(notificationEnabled: Bool, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.userNotificationPreference(notificationEnabled: notificationEnabled)
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    // For now we are not parsing the user object
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, errorMessage)
                
            } else {
                completion(true, "")
            }
        }
    }
    
    func profile(graphRetrieved: SimpleCompletionBlock?, completion: @escaping (_ success: Bool, _ profileInfo: ProfileInfo?, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.profile
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            var profile: ProfileInfo?
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    
                    if response.result != nil {
                        hasError = false
                        let dataInfo = response.result as! [String: Any]
                        profile = ProfileInfo(dataInfo, graphRetrieved: graphRetrieved)
                    }
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, nil, errorMessage)
                
            } else {
                completion(true, profile, errorMessage)
            }
        }
    }
    
    func getConfig(completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let apiConfig = JFUserEndpoint.config
        
        JFServerManager.shared.sendRequest(apiConfig: apiConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    // For now we are not parsing the user object
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if let dict = response.result as? [String: Any] {
                
                let imgURL = dict["imageUrl"] as? String ?? ""
                let thumbImgURL = dict["imageThumbnailUrl"] as? String ?? ""
                
                print("URLImageS3 received \(imgURL)\nThumbnail \(thumbImgURL) ")
                
                JFConstants.s3ImageURL = imgURL
                JFConstants.s3ThumbnailImageURL = thumbImgURL
                
                completion(true, "")
                
            } else {
                completion(false, "")
            }
        }
    }
    
    
    func updateProfileImage(imageName: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let updateProfileConfig = JFUserEndpoint.profileImageUpdate(fileName: imageName)
        
        JFServerManager.shared.sendRequest(apiConfig: updateProfileConfig) { (response) in
            var hasError = true
            var errorMessage = JFConstants.servicesGenericErrorMessage
            
            if response.status {
                
                if response.serverStatusCode == JFServerResponseCode.validResponse.rawValue {
                    hasError = false
                    
                } else if response.serverStatusCode == JFServerResponseCode.alreadyExists.rawValue {
                    errorMessage = response.message
                    
                } else if response.serverStatusCode == JFServerResponseCode.failed.rawValue ||
                    response.serverStatusCode == JFServerResponseCode.notFound.rawValue {
                    errorMessage = response.message
                }
                
            } else {
                errorMessage = response.customErrorMessage()
            }
            
            if hasError == true {
                completion(false, "")
                
            } else {
                completion(true, "")
            }
        }
    }
}




class abc: Codable {
    var name = ""
}

class xyzd: abc {
    var lastName = ""
}




