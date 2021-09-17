//
//  AppDelegate.swift
//  Hackfest-swvl
//
//  Created by Umair on 28/03/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("\(String(describing: url.host)) custom url scheme is \(String(describing: url.queryParameters)) \npath\(url.pathComponents)")
        
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
                print("config retrieved")
            } else {
                print("Expired config")
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
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    
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
            print("Not first launch.")
            rootVC = UIViewController.getSocialLoginVC()
            
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: JFConstants.JFUserDefaults.launchedBefore)
            
            rootVC = UIViewController.getLandingVC()
        }
        
        let navViewController = UINavigationController(rootViewController: rootVC)
        if (window == nil) { window = UIWindow(frame: UIScreen.main.bounds) }
        
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
