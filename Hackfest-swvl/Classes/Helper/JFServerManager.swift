//
//  JFServerManager.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator
import SwiftyJSON

// MARK: -

enum JFServerRequestMethod: Int {
    case get = 0
    case post
    case put
    case delete
    case patch
    
    func toHTTPMethod() -> HTTPMethod {
        
        switch self {
        case .get:
            return .get
            
        case .post:
            return .post
            
        case .put:
            return .put
            
        case .delete:
            return .delete
            
        case .patch:
            return .patch
        }
    }
}

// MARK: -

struct JFServerSettings {
    static let ExpiryTime: TimeInterval = 30 // in second
    static let ErrorCode = 1234567
    static let ErrorMessage = NSLocalizedString("An error occured. Please Try again.", comment: "")
    static let APIDomain = "com.citrusbits.Hackfest-swvl.app.servermanager"
}

// MARK: -

typealias JFServerManagerCompletionBlock = (_ response: JFServerResponse) -> Void

// MARK: -

class JFServerManager: SessionManager {
    
    // MARK: -
    
    fileprivate var baseURL: URL?
    
    // MARK: -
    
    static let shared: JFServerManager = {
        let baseURL = URL(string: JFAppTarget.current.serverBasePath())
        let instance = JFServerManager(baseURL: baseURL)
        
        return instance
    }()
    
    init(baseURL: URL?) {
        super.init(configuration: JFServerManager.createSessionConfiguration(), delegate: SessionDelegate(), serverTrustPolicyManager: nil)
        
        var url = baseURL
        
        // Ensure terminal slash for baseURL path, so that NSURL relativeToURL works as expected
        if (((url?.path.count)! > 0) && !((url?.absoluteString.hasSuffix("/"))!)) {
            url = baseURL?.appendingPathComponent("")
        }
        
        self.baseURL = url
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    
    // MARK: -
    
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
//    func sendRequest(requestPath: String,
//                     parameters: [String: Any]?,
//                     method: JFServerRequestMethod,
//                     headers: [String: String]?,
//                     setAuth: Bool = true,
//                     completion: @escaping JFServerManagerCompletionBlock) -> DataRequest {
    
    @discardableResult
    func sendRequest(apiConfig: JFAPIConfig,
                     completion: @escaping JFServerManagerCompletionBlock) -> DataRequest {
        let fullURL = URL(string: apiConfig.path, relativeTo: baseURL)
        
        var requestHeaders = [String: String]()
        
        requestHeaders["device_type"] = "ios"
        requestHeaders["device_os"] = UIDevice.current.systemVersion
        requestHeaders["build_version"] = Bundle.main.appVersion
        
        if apiConfig.setAuth == true {
            requestHeaders["Authorization"] = JFAuthTokenManager.shared.getAuthToken()
        }
        
        if apiConfig.headers?.isEmpty == false {
            
            for key in (apiConfig.headers?.keys)! {
                requestHeaders[key] = apiConfig.headers![key]
            }
        }
        
        let request = self.request(fullURL!,
                                   method: apiConfig.method,
                                   parameters: apiConfig.parameters,
                                   encoding: (apiConfig.method == .get) ? URLEncoding.default : JSONEncoding.default,
                                   headers: requestHeaders).responseJSON { (response) in
                                    
                                    
                                    print("Calling Endpoint: \(response.request?.url?.absoluteString ?? "EmptyURL")")
                                    print("Passed Parameters: \(String(describing: apiConfig.parameters))")
                                    print("raw response: \(response)")
                                    
                                    var serverResponse: JFServerResponse!
                                    
                                    switch response.result {
                                        
                                    case .success(let value):
                                        var hasError = true
                                        var status = false
                                        var message = ""
                                        var resultError: Error? = nil
                                        var data: Any? = nil
                                        var serverStatusCode = 0
                                        var metaData = [String: Any]()
                                        
                                        let serverDataJson = JSON(value)
                                        
                                        if serverDataJson != JSON.null {
                                            status = true
                                            hasError = false
                                            
                                            if let serverMessage = serverDataJson["message"].string {
                                                message = serverMessage
                                            }
                                            
                                            if let authToken = serverDataJson["token"].string {
                                                JFAuthTokenManager.shared.saveToken(authToken)
                                                JFAuthTokenManager.shared.saveLastFetchDate(Date())
                                            }
                                            
                                            data = serverDataJson["data"].dictionaryObject
                                            
                                            if let meta = serverDataJson["metadata"].dictionaryObject {
                                                metaData = meta
                                            }
                                            
                                            if data is NSNull {
                                                data = nil
                                            }
                                            
                                            
                                            // Developer's Note: We are expecting token to be available inside the 'data' object as well
                                            if let dataObject = data, let authToken = JSON(dataObject)["token"].string {
                                                JFAuthTokenManager.shared.saveToken(authToken)
                                                JFAuthTokenManager.shared.saveLastFetchDate(Date())
                                            }
                                            
                                            if let statusCode = serverDataJson["statusCode"].int {
                                                serverStatusCode = statusCode
                                            }
                                        }
                                        
                                        if hasError == true {
                                            var userInfo = [String: Any]()
                                            userInfo[NSLocalizedDescriptionKey] = JFServerSettings.ErrorMessage
                                            
                                            let anError = NSError.init(domain: JFServerSettings.APIDomain, code: JFServerSettings.ErrorCode, userInfo: userInfo)
                                            
                                            resultError = anError as Error
                                        }
                                        
                                        serverResponse = JFServerResponse(status: status, serverStatusCode: serverStatusCode, response: response, metaData: metaData, result: data, error: resultError, message: message)
                                        
                                    case .failure(let error):
                                        serverResponse = JFServerResponse(status: false, serverStatusCode: 0, response: response, metaData: [String: Any](), result: nil, error: error, message: "")
                                    }
                                    
                                    // Authentication token is either expired or not sent so
                                    if (serverResponse.isUnauthorized()) {
//                                        let prevApiConfig = apiConfig
//                                        let prevCompletion = completion
                                        
//                                        JFAuthTokenManager.shared.forceFetchAuthToken(completion: { [weak self] (success, _) in
//                                            guard let strongSelf = self else { return }
//                                            
//                                            if success {
//                                                strongSelf.sendRequest(apiConfig: prevApiConfig,
//                                                                       completion: prevCompletion)
//                                                
//                                            } else {
//                                                completion(serverResponse)
//                                            }
//                                        })
                                        
                                        // Logout app because session expired
                                        NotificationCenter.default.post(name: JFConstants.Notifications.logout, object: nil)
                                        
                                    } else {
                                        completion(serverResponse)
                                    }
        }
        
        return request
    }
    
    
    func uploadImage(imageFile: UIImage, completion: ((_ success: Bool, _ fileName: String, _   : String?) -> ())?) {
        guard let imgData = UIImagePNGRepresentation(imageFile) else {
            completion?(false, "", "Image file currupted")
            return
        }
        
        print("Uploading image of size \(imgData.count / 1000) KB")
        
        let fullURL = URL(string: JFUserEndpoint.uploadS3Image.path, relativeTo: baseURL)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
        },
                         to:fullURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    
                    if let dict = response.result.value as? [String: Any] {
                        
                        if let uploadedFileName = (dict["data"] as? [String: Any])?["imageName"] as? String {
                            print("name found\(uploadedFileName)")
                            
                            completion?(true, uploadedFileName, nil)
                        
                        } else {
                            completion?(false, "", "Unable to parse response data")
                        }
                        
                        
                    } else {
                        completion?(false, "", "Unable to parse response data")
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completion?(false, "", encodingError.localizedDescription)
            }
        }
    }
    
    // MARK: -
    
    class func createSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = JFServerSettings.ExpiryTime
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return configuration
    }
}
