//
//  JFLocationAccessViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/17/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import CoreLocation

class JFLocationAccessViewController: JFViewController, CLLocationManagerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var allowButton: JFButton!
    @IBOutlet weak var notAllowButton: UIButton!
    
    //MARK:- Public properties
    var locationManager: CLLocationManager!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for location access vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
    }
    
    //MARK:- User actions
    @IBAction func allowButtonTapped(_ sender: JFButton) {
        allowTapped()
    }
    
    @IBAction func notAllowButtonTapped(_ sender: UIButton) {
        self.updatePrefereceToServerAndContinueSignup(locationEnabled: false)
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "LOCATION ACCESS"
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func navigateToNextScreen() {
        let tabBarVC = getTabbarVC()
        tabBarVC.fromSignUpProcess = true
        UIApplication.shared.keyWindow?.swapRootViewControllerWithAnimation(newViewController: tabBarVC, animationType: .push)
    }
    
    func locationAccess() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted:
            print("No access yet")
            
        case .denied:
            print("Don't allow")
            
            UIAlertController.showAlert(inViewController: self, title: "Hackfest-swvl", message: "Location services permission not allowed, you can change permission from Setting", okButtonTitle: "Settings", cancelButtonTitle: "Not now") { (success) in
                
                if success {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                    
                } else {
                    // Do nothing for now
                }
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Allow")
            JFUtility.updateLocation()
            self.updatePrefereceToServerAndContinueSignup(locationEnabled: true)
        }
    }
    
    func allowTapped() {
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationAccess()
            
        } else {
            UIAlertController.showAlert(inViewController: self, title: "Hackfest-swvl", message: "Location services are disabled, you can enable location services from Setting", okButtonTitle: "Settings", cancelButtonTitle: "Not now") { (success) in
                
                if success {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                            self.locationManager.delegate = nil
                        })
                    }
                    
                } else {
                    // Do nothing for now
                }
            }
        }
        
    }
}

//MARK:- Network calls
extension JFLocationAccessViewController {
    func updatePrefereceToServerAndContinueSignup(locationEnabled: Bool) {
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.updatingPreference, animated: true)
        
        JFWSAPIManager.shared.updateLocationPreference(locationEnabled: locationEnabled) { [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.navigationController?.view)!, animated: true)
            
            if success {
                // Developer's Note: This needs to be changed
                strongSelf.navigateToNextScreen()//signupUser() replace with other api flow
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.updatePrefereceToServerAndContinueSignup(locationEnabled: locationEnabled)
                    }
                }
            }
        }
    }
}
