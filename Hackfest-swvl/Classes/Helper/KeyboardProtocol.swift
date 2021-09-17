//
//  KeyboardProtocol.swift
//  ZENFoods
//
//  Created by Abdul Baseer Khan on 01/02/2018.
//  Copyright © 2018 Loviza Tahir. All rights reserved.
//

import Foundation

import UIKit

typealias EmptyEvent = () -> ()
typealias CGFloatEvent = (CGFloat) -> Void

protocol KeyboardProtocol {
}

extension KeyboardProtocol where Self: UIViewController {
    
    func addKeyboardShowObserver( completion: EmptyEvent? = nil, onShowEvent: CGFloatEvent?) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil ) { [weak self] notification in
            let userInfo = notification.userInfo! as NSDictionary
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
                let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! UInt
                
                self?.view.setNeedsLayout()
                onShowEvent?(keyboardHeight)
                self?.view.setNeedsUpdateConstraints()
                
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                    //self.view.layoutIfNeeded()
                }) { _ in
                    completion?()
                }
            }
        }
    }
    
    func addKeyboardHideObserver(onHideEvent: EmptyEvent?) {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil ) { [weak self] notification in
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
            let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! UInt
            
            self?.view.setNeedsLayout()
            onHideEvent?()
            self?.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                //self.view.layoutIfNeeded()
            }
            )
        }
    }
    
}
