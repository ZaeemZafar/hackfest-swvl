//
//  JFAuthTokenManager.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

private let codeForAuthToken = ""
private let authTokenValueKey = "authTokenValue"
private let authTokenLastFetchDateKey = "authTokenLastFetchDate"
private let authTokenReFetchInterval = ((20.0 * 24 * 60.0 * 60.0) - 60.0) // 20 days - one minute

// MARK: -

class JFAuthTokenManager: NSObject {
    
    // MARK: -
    
    fileprivate var canSendAuthTokenRequest = true
    
    // MARK: -
    
    static let shared: JFAuthTokenManager = {
        let instance = JFAuthTokenManager()
        return instance
    }()
    
    override init() {
        super.init()
        loadDefaults()
    }
    
    // MARK: -
    
    func hasAuthToken() -> Bool {
        let token = getAuthToken()
        return (token.count > 0)
    }
    
    func getAuthToken() -> String {
        return UserDefaults.standard.object(forKey: authTokenValueKey) as? String ?? ""
    }
    
    func saveToken(_ authToken: String) {
        print(authToken)
        
        UserDefaults.standard.set(authToken, forKey: authTokenValueKey)
        UserDefaults.standard.synchronize()
    }
    
    func saveLastFetchDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: authTokenLastFetchDateKey)
        UserDefaults.standard.synchronize()
    }
    
    func lastFetchDate() -> Date? {
        return UserDefaults.standard.object(forKey: authTokenLastFetchDateKey) as? Date ?? nil
    }
    
    // This will return true if token is not exipred
    func fetchAuthToken(completion: @escaping (_ success: Bool) -> Void) {
        
        if shouldFetchAuthToken() {
            
            forceFetchAuthToken(completion: { (success, _) in
                completion(success)
            })
        }
    }
    
    // This will always fetch token wheather required or not
    func forceFetchAuthToken(completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        
        // Check that request is already in process
        if canSendAuthTokenRequest == false {
            return
        }
        
        // Set false to avoid other calls
        canSendAuthTokenRequest = false
        
        var headers = [String: String]()
        headers["authkey"] = encryptedAuthCode()
        
        // Service call for authentication token fetch
    }
    
    // MARK: -
    
    fileprivate func loadDefaults() {
        
    }
    
    fileprivate func shouldFetchAuthToken() -> Bool {
        var isRequired = true
        
        if let lastFetch = lastFetchDate() {
            
            if fabs(lastFetch.timeIntervalSinceNow) < authTokenReFetchInterval {
                isRequired = false
            }
        }
        
        return isRequired
    }
    
    fileprivate func encryptedAuthCode() -> String {
        let plainString = codeForAuthToken
        return plainString
    }
}

