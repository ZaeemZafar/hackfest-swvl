//
//  JFSignUpUser.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/16/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import Foundation

class JFSignUpUser {
    
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var phoneNumber: String
    var image: String
    var imageURL: URL?
    var traitAppearance: Bool
    var traitPersonality: Bool
    var traitIntelligence: Bool
    var traitNone: Bool
    var notificationsEnabled: Bool
    var locationEnabled: Bool
    var isCaptainProfile: Bool
    var deviceUID: String
    var deviceType: String
    var facebookID: String
    var facebookProfileLink: String
    
    private var _imageFile: UIImage?
    
    var imageFile: UIImage? {
        
        set {
            
            if let newImage = newValue {
                JFServerManager.shared.uploadImage(imageFile: newImage, completion: { [weak self] (success, fileName, errorMessage) in
                    self?.image = fileName
                })
            }
            
            _imageFile = newValue
        }
        
        get {
            return _imageFile
        }
    }
    
    var deviceToken: String {
        get {
            return JFNotificationManager.shared.fcmPushToken
        }
    }
    
    init() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        phoneNumber = ""
        image = ""
        traitAppearance = false
        traitPersonality = false
        traitIntelligence = false
        traitNone = false
        notificationsEnabled = false
        locationEnabled = false
        isCaptainProfile = true
        deviceUID = ""
        deviceType = ""
        facebookID = ""
        facebookProfileLink = ""
    }
}
