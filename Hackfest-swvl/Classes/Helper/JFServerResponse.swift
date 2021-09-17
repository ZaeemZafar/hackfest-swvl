//
//  JFServerResponse.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum JFServerResponseCode: Int, Codable {
    case okay = 100                   // Action successful
    case authorizationFail = 101    // Insufficient rights
    case invalidParameters = 102    // Invalid Parameters
    case listingOk = 103            // Listing successful
    case noRecords = 104            // No records found
    case failed = 105               // Action failed
    case notFound = 106             // Requested resource does not exists
    case alreadyExists = 304        // Resource already exists
    case validResponse = 200   
}

// MARK: -

struct JFServerResponse {
    let status: Bool
    let serverStatusCode: Int
    let response: DataResponse<Any>?
    let metaData: [String: Any]
    let result: Any?
    let error: Error?
    let message: String
    
    init(status: Bool, serverStatusCode: Int, response: DataResponse<Any>?, metaData: [String: Any], result: Any?, error: Error?, message: String) {
        self.status = status
        self.serverStatusCode = serverStatusCode
        self.response = response
        self.result = result
        self.error = error
        self.message = message
        self.metaData = metaData
    }
    
    func statusCode() -> Int {
        var code = (self.error as NSError?)?.code
        
        if let httpResponse = response?.response {
            code = httpResponse.statusCode
        }
        
        return code ?? 0
    }
    
    func responseDataString() -> String {
        
        if let dataString = String(data: (response?.data)!, encoding: .utf8) {
            return dataString
        }
        
        return ""
    }
    
    func isTimedOut() -> Bool {
        let code = (self.error as NSError?)?.code
        return (code == NSURLErrorTimedOut)
    }
    
    func isCancelled() -> Bool {
        let code = (self.error as NSError?)?.code
        return (code == NSURLErrorCancelled)
    }
    
    func isNetworkConnectionLost() -> Bool {
        let code = (self.error as NSError?)?.code
        return (code == NSURLErrorNetworkConnectionLost)
    }
    
    func notConnectedToInternet() -> Bool {
        let code = (self.error as NSError?)?.code
        return (code == NSURLErrorNotConnectedToInternet)
    }
    
    func isServerDown() -> Bool {
        let code = statusCode()
        return (code == 500 || code == 501 || code == 502 || code == 503 || code == 504)
    }
    
    func isUnauthorized() -> Bool {
        let code = statusCode()
        return (code == 401)
    }
    
    func customErrorMessage() -> String {
        var errorMessage = JFConstants.servicesGenericErrorMessage
        
        if isNetworkConnectionLost() || notConnectedToInternet() {
            errorMessage = JFLocalizableConstants.NetworkError
            
        } else if isServerDown() {
            errorMessage = NSLocalizedString("Ooops, looks like something went completely wrong!\n\nPlease try again.", comment: "")
            
        } else {
            errorMessage = error?.localizedDescription ?? errorMessage
        }
        
        return errorMessage
    }
    
    func httpBodyString() -> String {
        return String(data: (response?.request?.httpBody)!, encoding: String.Encoding.utf8)!
    }
}

