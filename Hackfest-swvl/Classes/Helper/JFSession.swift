//
//  JFSession.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

enum UserDefaultKeys: String {
    case deviceToken
    case logInStatus
    case userProfile
}

// MARK: -

class JFSession: NSObject {

    // MARK: - Public Properties
    private var _userProfile: ProfileInfo?
    
    // MARK: -
    var myProfile: ProfileInfo? {
        get {
            return _userProfile
        }
        
        set {
            _userProfile = newValue
            
            saveUserProfile(newValue)
        }
    }
    
    static let shared: JFSession = {
        let instance = JFSession()
        return instance
    }()
    
    override init() {
        super.init()
        loadDefaults()
    }
    
    // MARK: -
    
    func setLogInStatus() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.logInStatus.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func clearLogInStatus() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.logInStatus.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userProfile.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.deviceToken.rawValue)
        UserDefaults.standard.synchronize()
        
        // Also reset local variable for user profile
        _userProfile = nil
    }
    
    func isLogIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.logInStatus.rawValue)
    }
    
    func saveDeviceToken(_ deviceToken: String) {
        print(deviceToken)
        
        UserDefaults.standard.set(deviceToken, forKey: UserDefaultKeys.deviceToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func saveUserProfile(_ profile: ProfileInfo?) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultKeys.userProfile.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func deviceToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.deviceToken.rawValue) ?? ""
    }
    
    // MARK: -
    fileprivate func loadDefaults() {
        let decoder = JSONDecoder()
        
        if let profileData = UserDefaults.standard.data(forKey: UserDefaultKeys.userProfile.rawValue),
            let profileInfo = try? decoder.decode(ProfileInfo.self, from: profileData) {
            _userProfile = profileInfo
        }
        
    }
}

