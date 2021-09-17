//
//  File.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 14/07/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseMessaging
import MobileCoreServices

typealias JVFNotificationResponseHandler = ((_ data: JFPushNotificationData) -> Void)

class JFNotificationManager: NSObject {
    static let shared = JFNotificationManager()
    
    var fcmPushToken: String = ""
    
    func configure() {
        
        // Check for Firebase configuration whether its already exisits. if so, then no need to initiaze it again
        if let _ = FirebaseApp.app() {
            return
        }
        
        setupPushNotification()
        configureGoogleFirebaseMessaging()
        JFUtility.checkPushNotificationPermissionWRTPreferences()
    }
    
    func setupPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func configureGoogleFirebaseMessaging() {
        let filePath = Bundle.main.path(forResource: JFAppTarget.current.googleFirebaseIdentifier, ofType: "plist")!
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
        Messaging.messaging().delegate = self
    }
    
    func notificationManager(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(#function)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNS token is \(deviceTokenString)")
    }
    
    func notificationManager(didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error occured while registering for push \(error)")
    }
}

extension JFNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive
        response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {
        print(#function)

        let userInfo = response.notification.request.content.userInfo

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        let userID = userInfo["id"] as? String ?? ""
        let pushTypeString = userInfo["type"] as? String ?? ""
        let pushType = JFPushNotificationType(rawValue: pushTypeString) ?? .undefined
        let notificationData = JFPushNotificationData(user_id: userID, notification_type: pushType, triggered_appLaunch: true)
        NotificationCenter.default.post(name: JFConstants.Notifications.push, object: notificationData)
        
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
        notification: UNNotification, withCompletionHandler
        completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(#function)

        let userInfo = notification.request.content.userInfo

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
        
        let userID = userInfo["id"] as? String ?? ""
        let pushTypeString = userInfo["type"] as? String ?? ""
        let pushType = JFPushNotificationType(rawValue: pushTypeString) ?? .undefined
        let notificationData = JFPushNotificationData(user_id: userID, notification_type: pushType, triggered_appLaunch: false)
        NotificationCenter.default.post(name: JFConstants.Notifications.push, object: notificationData)

        if JFAppTarget.current == .development || JFAppTarget.current == .qa {
            completionHandler([.badge, .alert, .sound])
        } else {
            completionHandler([.badge])
        }
    }
}

extension JFNotificationManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(#function)
        print("FCM token \(fcmToken)")
        
        self.fcmPushToken = fcmToken
        
        if JFSession.shared.isLogIn() {
            let endPoint = JFUserEndpoint.updatePushTokenOnServer
            JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { (response: JFWepAPIResponse<GenericResponse>) in
                
                print("Push token \(response.success) updated on server")
            }
        }
        
        
        if JFAppTarget.current == .development {
            let copyString = "FCMToken is \(fcmToken)\n\nOn Date: \(Date())"
            UIPasteboard.general.string = copyString
        }
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(#function)

        print("Remote Message is \(remoteMessage.appData)")
    }
}

// Notifications
extension JFNotificationManager {
    func didReceiveNotification(ofType notification_type: JFPushNotificationType, performAction: JVFNotificationResponseHandler?) {
        NotificationCenter.default.addObserver(forName: JFConstants.Notifications.push, object: nil, queue: nil) { (notification) in
            print(#function)
            guard let notificationData = notification.object as? JFPushNotificationData else { return }
            
            if notificationData.type == notification_type {
                performAction?(notificationData)
                
            } else {
                // Do nothing…
                print("Some other type")
            }
            
        }
    }
    
    func didReceiveNotification(ofType notification_types: [JFPushNotificationType], performAction: JVFNotificationResponseHandler?) {
        NotificationCenter.default.addObserver(forName: JFConstants.Notifications.push, object: nil, queue: nil) { (notification) in
            print(#function)
            
            guard let notificationData = notification.object as? JFPushNotificationData else { return }
            
            if notification_types.contains(notificationData.type) {
                performAction?(notificationData)
                
            } else {
                // Do nothing…
                print("Some other type")
            }
        }
    }
    
    func onNotificationReceive(_ performAction: JVFNotificationResponseHandler?) {
        
        NotificationCenter.default.addObserver(forName: JFConstants.Notifications.push, object: nil, queue: nil) { (notification) in
            print(#function)
            guard let notificationData = notification.object as? JFPushNotificationData else { return }
            
            performAction?(notificationData)
        }
    }
}

class JFPushNotificationData {
    var type: JFPushNotificationType
    var userID: String
    var triggeredFromAppLaunch: Bool
    
    init(user_id: String, notification_type: JFPushNotificationType, triggered_appLaunch: Bool) {
        userID = user_id
        type = notification_type
        triggeredFromAppLaunch = triggered_appLaunch
    }
}

