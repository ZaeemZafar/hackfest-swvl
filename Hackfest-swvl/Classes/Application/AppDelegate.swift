//
//  AppDelegate.swift
//  Hackfest-swvl
//
//  Created by Umair on 28/03/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import Droar


let gcmMessageIDKey = "gcm.message_id"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var cells = [DroarCell]()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppConfiguration()
        
        // Appearance
        JFUtility.setupAppAppearance()
        
        // set Landing Screen
        setLandingScreen()


        // Setup Droar if not production/appStore
        if JFAppTarget.current != JFAppTarget.appStore {
            UserDefaults.standard.set(false, forKey: JFConstants.JFUserDefaults.droarLocationEnabled)
            UserDefaults.standard.set(false, forKey: JFConstants.JFUserDefaults.droarMultiplierEnabled)
            
            Droar.start()
            Droar.register(self)
        }
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        debugPrint("\(String(describing: url.host)) custom url scheme is \(String(describing: url.queryParameters)) \npath\(url.pathComponents)")
        
        return JFUtility.handleCustomURLScheme(url: url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JFNotificationManager.shared.notificationManager(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        JFNotificationManager.shared.notificationManager(didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func setupAppConfiguration() {
        JFWSAPIManager.shared.getConfig { (success, errorMessage) in
            
            if success {
                debugPrint("config retrieved")
            } else {
                debugPrint("Expired config")
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: JFConstants.Notifications.logout, object: nil)
        
        //Hide Autolayout Warning
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
        // Don't remove this line, it basically initializes shared object and mark the authorization status
        JFContacts.shared.loadInitialData()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        
        // Print full message.
        debugPrint(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        
        // Print full message.
        debugPrint(userInfo)
    
        completionHandler(UIBackgroundFetchResult.newData)
    }
    

    @objc func logout() {
        UIApplication.notificationBadgeCount = 0
        
        if JFSession.shared.isLogIn() == false {
            // Just a safe check to make sure persisted data is being cleared
            JFSession.shared.clearLogInStatus()
            return
        }
        
        JFSession.shared.clearLogInStatus()
        
        let alert = UIAlertController(title: "Session Expired", message: "Your session has expired. Please login again to renew your session and continue using Hackfest-swvl.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel) { success in
            self.setRootViewController()
        }
        
        alert.addAction(cancelButton)
        
        UIApplication.topViewController()?.present(alert, animated: true)
    }
    
    func setRootViewController(withAnimation animation: Bool = false) {
        // TODO: Naming ~ fixed
        // User defauls keys should always define as constants ~ fixed
        // Why VC is violating naming convention! ~fixed
        // Why we are initializing VC with UIVIewController()! ~ fixed
        let launchedBefore = UserDefaults.standard.bool(forKey: JFConstants.JFUserDefaults.launchedBefore)
        
        var rootVC: UIViewController
        
        if launchedBefore  {
            debugPrint("Not first launch.")
            rootVC = UIViewController.getSocialLoginVC()
            
        } else {
            debugPrint("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: JFConstants.JFUserDefaults.launchedBefore)
            
            rootVC = UIViewController.getLandingVC()
        }
        
        let navViewController = UINavigationController(rootViewController: rootVC)
        
        if (window == nil) {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .white
        }
        
        if animation {
          window?.swapRootViewControllerWithAnimation(newViewController: navViewController, animationType: .pop)
        } else {
         window?.rootViewController = navViewController
        }
        
        window?.makeKeyAndVisible()
    }
 
    func setLandingScreen() {
        
        if  JFSession.shared.isLogIn() {
            let tabBarVC = UIViewController.getTabbarVC()
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = tabBarVC
            window?.makeKeyAndVisible()
            
        } else {
           setRootViewController()
        }
    }
}
