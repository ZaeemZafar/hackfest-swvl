//
//  UIAlertController+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 16/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    class func showOkayAlert(inViewController: UIViewController, message: String, title: String = JFLocalizableConstants.AlertTitle, completion: (() -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: JFLocalizableConstants.OKTitle,
                                     style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                        
                                        if completion != nil {
                                            completion!()
                                        }
        }
        
        alertController.addAction(okAction)
        inViewController.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(inViewController vc:UIViewController, title: String, message: String, okButtonTitle: String, cancelButtonTitle: String, isActionSheet: Bool = false, isButtonTypeDestructive: Bool = false, isSingleButtonAlert: Bool = false, completion:@escaping ((Bool) -> ())) {
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: isActionSheet ? .actionSheet : .alert)

        let settingsAction = UIAlertAction(title: okButtonTitle, style: isButtonTypeDestructive ? .destructive : .default) { (_) -> Void in
            completion(true)
        }
        
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { (action) in
            completion(false)
        }
        
        if isSingleButtonAlert == false {
           alertController.addAction(settingsAction)
        }
        alertController.addAction(cancelAction)

        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showSingleButtonAlert(inViewController vc:UIViewController, title: String, message: String, okButtonTitle: String, cancelButtonTitle: String, isActionSheet: Bool = false, completion:@escaping ((Bool) -> ())) {
        
        let alertController = UIAlertController()
        
        let settingsAction = UIAlertAction(title: okButtonTitle, style: .destructive) { (_) -> Void in
            completion(true)
        }
        
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { (action) in
            completion(false)
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithSettingsPrompt(title: String, message: String, fromViewController: UIViewController, completion: CompletionBlockWithBool? = nil) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            completion?(true)
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Not now", style: .cancel, handler: { (_) -> Void in
            completion?(false)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)

        fromViewController.present(alertController, animated: true, completion: nil)
    }
}


// Third party extension
// https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/UIKit/UIAlertControllerExtensions.swift
public extension UIAlertController {
    
    /// SwifterSwift: Add an action to Alert
    ///
    /// - Parameters:
    ///   - title: action title
    ///   - style: action style (default is UIAlertActionStyle.default)
    ///   - isEnabled: isEnabled status for action (default is true)
    ///   - handler: optional action handler to be called when button is tapped (default is nil)
    /// - Returns: action created by this method
    @discardableResult public func addAction(title: String, style: UIAlertActionStyle = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        addAction(action)
        return action
    }
    
    /// SwifterSwift: Add a text field to Alert
    ///
    /// - Parameters:
    ///   - text: text field text (default is nil)
    ///   - placeholder: text field placeholder text (default is nil)
    ///   - editingChangedTarget: an optional target for text field's editingChanged
    ///   - editingChangedSelector: an optional selector for text field's editingChanged
    public func addTextField(text: String? = nil, placeholder: String? = nil, editingChangedTarget: Any?, editingChangedSelector: Selector?, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false) {
        addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if isSecureTextEntry {
                textField.isSecureTextEntry = true
            }
            textField.keyboardType = keyboardType
            if let target = editingChangedTarget, let selector = editingChangedSelector {
                textField.addTarget(target, action: selector, for: .editingChanged)
            }
        }
    }
    
}

// MARK: - Initializers
public extension UIAlertController {
    
    /// SwifterSwift: Create new alert view controller with default OK action.
    ///
    /// - Parameters:
    ///   - title: alert controller's title.
    ///   - message: alert controller's message (default is nil).
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    public convenience init(title: String, message: String? = nil, defaultActionButtonTitle: String = "OK", tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
    /// SwifterSwift: Create new error alert view controller from Error with default OK action.
    ///
    /// - Parameters:
    ///   - title: alert controller's title (default is "Error").
    ///   - error: error to set alert controller's message to it's localizedDescription.
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    public convenience init(title: String = "Error", error: Error, defaultActionButtonTitle: String = "OK", preferredStyle: UIAlertControllerStyle = .alert, tintColor: UIColor? = nil) {
        self.init(title: title, message: error.localizedDescription, preferredStyle: preferredStyle)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
}
