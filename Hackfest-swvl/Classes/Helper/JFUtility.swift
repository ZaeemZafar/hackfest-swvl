//
//  File.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 27/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftLocation
import UserNotifications
import MapKit

final class JFUtility {
    
    class func checkPushNotificationPermissionWRTPreferences() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { settings in
            
            switch settings.authorizationStatus {
            case .denied:
                let notificationEnabled = JFSession.shared.myProfile?.notficationEnabled ?? false
                guard let topVC = UIApplication.topViewController() else {return}
                
                if notificationEnabled {
                    UIAlertController.showAlertWithSettingsPrompt(title: "Notification Permission", message: "This iPhone doesn't allow push notification for Hackfest-swvl app, please allow Hackfest-swvl to receive push notifications from Settings if you want to receive them.", fromViewController: topVC)
                }
                
            default:
                // Do nothing for now
                break
            }
        })
    }
    
    class func handleCustomURLScheme(url: URL) -> Bool {
        let urlSchemePath = CustomURLSchemePath(rawValue: (url.pathComponents[safe: 1] ?? "").lowercased()) ?? .none
        let queryParameters = url.queryParameters
        
        switch urlSchemePath {
            
        case .resetPassword:
            let message = NSLocalizedString("Your reset password link is no longer valid.", comment: "")
            
            if let code = queryParameters?["code"] {
                
                if code.equalIgnoreCase("expired") == false {
                    let resetVC = UIStoryboard.userRegistration.instantiateViewController(withIdentifier: "JFResetPasswordViewController") as! JFResetPasswordViewController
                    resetVC.resetCode = code
                    
                    let navViewController = UINavigationController(rootViewController: resetVC)
                    UIApplication.shared.keyWindow?.swapRootViewControllerWithAnimation(newViewController: navViewController, animationType: .push)
                    
                } else {
                    UIAlertController.showOkayAlert(inViewController: UIApplication.topViewController()!, message: message)
                }
                
            } else {
                UIAlertController.showOkayAlert(inViewController: UIApplication.topViewController()!, message: message)
            }
            
            return true
            
        case .updateEmail:
            var message = ""
            
            if queryParameters?["status"] == "success" {
                message = NSLocalizedString("Email has successfully updated.", comment: "")
                
                // Refersh User if use still logged in
                if (JFSession.shared.isLogIn()) {
                    // TODO: Implement user object in JFSession class and simply update that user object here
                    // For now we are sending notification so that corresponding view update respectively
                    NotificationCenter.default.post(name: JFConstants.Notifications.emailUpdated, object: nil)
                }
                
            } else {
                message = NSLocalizedString("Your email confirmation link is no longer valid.", comment: "")
            }
            
            UIAlertController.showOkayAlert(inViewController: UIApplication.topViewController()!, message: message)
            
            return true
            
        case .none:
            // Do nothing for now
            return false
        }
    }
    
    class func updateLocation(completion: CompletionBlockWithLocationCoordinate? = nil) {
        if JFSession.shared.isLogIn() == false {
            completion?(false, nil)
            return
        }
        
        Locator.currentPosition(accuracy: .city, onSuccess: { location -> (Void) in
            print("Location found: \(location)")
            let endPoint = JFUserEndpoint.updateLocation(longitude: String(location.coordinate.longitude), latitude: String(location.coordinate.latitude))
            
            JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { (response: JFWepAPIResponse<GenericResponse>) in
                completion?(response.success, location.coordinate)
                
                if response.success {
                    print("Successfully location updated")
                }
            }
            
        }) { err, last -> (Void) in
            completion?(false, nil)
            print("Failed to get location: \(err)")
        }
    }
    
    class func updateUserLocationToServer(alertsAllowed: Bool = true, completion: CompletionBlockWithLocationCoordinate? = nil) {
        let locationPermissionStatus = CLLocationManager.authorizationStatus()
        
        if locationPermissionStatus == .notDetermined {
            if alertsAllowed {
                Locator.requestAuthorizationIfNeeded(.whenInUse)
            }
        }

        if JFSession.shared.myProfile?.locationEnabled == true {

            if CLLocationManager.locationServicesEnabled() {
                // Manually request given authorization
                Locator.requestAuthorizationIfNeeded(.whenInUse)
                
                switch locationPermissionStatus {
                case .restricted, .denied:
                    print("No access")
                    
                    if alertsAllowed {
                        let alert = UIAlertController(title: "Location Permission", message: "You are not allowed to access system Location, please allow Hackfest-swvl to access Location from Settings.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                            let url = URL(string: UIApplicationOpenSettingsURLString)!
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }))
                        
                        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                    }
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    updateLocation(completion: completion)
                    
                default:
                    print("Its default")
                }
            } else {
                if alertsAllowed {
                    let alert = UIAlertController(title: "Location Services Disabled", message: "In order to see nearby people, please turn on your device location services.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        let url = URL(string: UIApplicationOpenSettingsURLString)!
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }))
                    
                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    class func setupAppAppearance() {
        // UITabbar
        let titleFontAll : UIFont = UIFont.medium(fontSize: 11)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : titleFontAll], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : titleFontAll], for: .selected)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        
        // UIPageControl
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.jfLightGray
        pageControl.currentPageIndicatorTintColor = UIColor.jfMediumGray
        
        // UINavigationBar
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.jfDarkGray,
            NSAttributedStringKey.font: UIFont.medium(fontSize: 14.0)
        ]
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().isTranslucent = false
    }

    class func getCountryCode() -> String? {

        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            
            var countryDictionary  = ["AF":"93",
                                      "AL":"355",
                                      "DZ":"213",
                                      "AS":"1",
                                      "AD":"376",
                                      "AO":"244",
                                      "AI":"1",
                                      "AG":"1",
                                      "AR":"54",
                                      "AM":"374",
                                      "AW":"297",
                                      "AU":"61",
                                      "AT":"43",
                                      "AZ":"994",
                                      "BS":"1",
                                      "BH":"973",
                                      "BD":"880",
                                      "BB":"1",
                                      "BY":"375",
                                      "BE":"32",
                                      "BZ":"501",
                                      "BJ":"229",
                                      "BM":"1",
                                      "BT":"975",
                                      "BA":"387",
                                      "BW":"267",
                                      "BR":"55",
                                      "IO":"246",
                                      "BG":"359",
                                      "BF":"226",
                                      "BI":"257",
                                      "KH":"855",
                                      "CM":"237",
                                      "CA":"1",
                                      "CV":"238",
                                      "KY":"345",
                                      "CF":"236",
                                      "TD":"235",
                                      "CL":"56",
                                      "CN":"86",
                                      "CX":"61",
                                      "CO":"57",
                                      "KM":"269",
                                      "CG":"242",
                                      "CK":"682",
                                      "CR":"506",
                                      "HR":"385",
                                      "CU":"53",
                                      "CY":"537",
                                      "CZ":"420",
                                      "DK":"45",
                                      "DJ":"253",
                                      "DM":"1",
                                      "DO":"1",
                                      "EC":"593",
                                      "EG":"20",
                                      "SV":"503",
                                      "GQ":"240",
                                      "ER":"291",
                                      "EE":"372",
                                      "ET":"251",
                                      "FO":"298",
                                      "FJ":"679",
                                      "FI":"358",
                                      "FR":"33",
                                      "GF":"594",
                                      "PF":"689",
                                      "GA":"241",
                                      "GM":"220",
                                      "GE":"995",
                                      "DE":"49",
                                      "GH":"233",
                                      "GI":"350",
                                      "GR":"30",
                                      "GL":"299",
                                      "GD":"1",
                                      "GP":"590",
                                      "GU":"1",
                                      "GT":"502",
                                      "GN":"224",
                                      "GW":"245",
                                      "GY":"595",
                                      "HT":"509",
                                      "HN":"504",
                                      "HU":"36",
                                      "IS":"354",
                                      "IN":"91",
                                      "ID":"62",
                                      "IQ":"964",
                                      "IE":"353",
                                      "IL":"972",
                                      "IT":"39",
                                      "JM":"1",
                                      "JP":"81",
                                      "JO":"962",
                                      "KZ":"77",
                                      "KE":"254",
                                      "KI":"686",
                                      "KW":"965",
                                      "KG":"996",
                                      "LV":"371",
                                      "LB":"961",
                                      "LS":"266",
                                      "LR":"231",
                                      "LI":"423",
                                      "LT":"370",
                                      "LU":"352",
                                      "MG":"261",
                                      "MW":"265",
                                      "MY":"60",
                                      "MV":"960",
                                      "ML":"223",
                                      "MT":"356",
                                      "MH":"692",
                                      "MQ":"596",
                                      "MR":"222",
                                      "MU":"230",
                                      "YT":"262",
                                      "MX":"52",
                                      "MC":"377",
                                      "MN":"976",
                                      "ME":"382",
                                      "MS":"1",
                                      "MA":"212",
                                      "MM":"95",
                                      "NA":"264",
                                      "NR":"674",
                                      "NP":"977",
                                      "NL":"31",
                                      "AN":"599",
                                      "NC":"687",
                                      "NZ":"64",
                                      "NI":"505",
                                      "NE":"227",
                                      "NG":"234",
                                      "NU":"683",
                                      "NF":"672",
                                      "MP":"1",
                                      "NO":"47",
                                      "OM":"968",
                                      "PK":"92",
                                      "PW":"680",
                                      "PA":"507",
                                      "PG":"675",
                                      "PY":"595",
                                      "PE":"51",
                                      "PH":"63",
                                      "PL":"48",
                                      "PT":"351",
                                      "PR":"1",
                                      "QA":"974",
                                      "RO":"40",
                                      "RW":"250",
                                      "WS":"685",
                                      "SM":"378",
                                      "SA":"966",
                                      "SN":"221",
                                      "RS":"381",
                                      "SC":"248",
                                      "SL":"232",
                                      "SG":"65",
                                      "SK":"421",
                                      "SI":"386",
                                      "SB":"677",
                                      "ZA":"27",
                                      "GS":"500",
                                      "ES":"34",
                                      "LK":"94",
                                      "SD":"249",
                                      "SR":"597",
                                      "SZ":"268",
                                      "SE":"46",
                                      "CH":"41",
                                      "TJ":"992",
                                      "TH":"66",
                                      "TG":"228",
                                      "TK":"690",
                                      "TO":"676",
                                      "TT":"1",
                                      "TN":"216",
                                      "TR":"90",
                                      "TM":"993",
                                      "TC":"1",
                                      "TV":"688",
                                      "UG":"256",
                                      "UA":"380",
                                      "AE":"971",
                                      "GB":"44",
                                      "US":"1",
                                      "UY":"598",
                                      "UZ":"998",
                                      "VU":"678",
                                      "WF":"681",
                                      "YE":"967",
                                      "ZM":"260",
                                      "ZW":"263",
                                      "BO":"591",
                                      "BN":"673",
                                      "CC":"61",
                                      "CD":"243",
                                      "CI":"225",
                                      "FK":"500",
                                      "GG":"44",
                                      "VA":"379",
                                      "HK":"852",
                                      "IR":"98",
                                      "IM":"44",
                                      "JE":"44",
                                      "KP":"850",
                                      "KR":"82",
                                      "LA":"856",
                                      "LY":"218",
                                      "MO":"853",
                                      "MK":"389",
                                      "FM":"691",
                                      "MD":"373",
                                      "MZ":"258",
                                      "PS":"970",
                                      "PN":"872",
                                      "RE":"262",
                                      "RU":"7",
                                      "BL":"590",
                                      "SH":"290",
                                      "KN":"1",
                                      "LC":"1",
                                      "MF":"590",
                                      "PM":"508",
                                      "VC":"1",
                                      "ST":"239",
                                      "SO":"252",
                                      "SJ":"47",
                                      "SY":"963",
                                      "TW":"886",
                                      "TZ":"255",
                                      "TL":"670",
                                      "VE":"58",
                                      "VN":"84",
                                      "VG":"284",
                                      "VI":"340"]
            
            if let countryPhoneCode = countryDictionary[countryCode] {
                return countryPhoneCode
            }
            
        }
        
        return nil
    }
    
    class func openInMap(locationCoordinate coordinate: CLLocationCoordinate2D?, regionDistance: CLLocationDistance = 5000, markerTitle: String = "User Location") {
        guard let locationCoordinate = coordinate  else {
            return
        }
        
        let coordinates = CLLocationCoordinate2DMake(locationCoordinate.latitude, locationCoordinate.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = markerTitle
        mapItem.openInMaps(launchOptions: options)
    }
}

extension UIApplication {
    class var notificationBadgeCount: Int {
        get {
            return UIApplication.shared.applicationIconBadgeNumber
        }

        set {
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
    
    class var hasNotifications: Bool {
        return notificationBadgeCount > 0
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let finalValue = (self * divisor).rounded() / divisor
        
        return (finalValue == 0 ) ? 0.0 : finalValue
    }
    
    var intValue: Int {
        return Int(self)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
