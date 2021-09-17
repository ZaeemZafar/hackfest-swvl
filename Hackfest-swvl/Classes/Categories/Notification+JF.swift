//
//  Notification+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit

extension NSNotification {
    
    func keyboardSizeForView(view: UIView) -> CGRect? {
        var coords: CGRect? = nil
        
        let rawKeyboardRect = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        if let properlyRotatedCoords = view.window?.convert(rawKeyboardRect!, to: view) {
            coords = properlyRotatedCoords
        }
        
        return coords
    }
}

// MARK: -

extension Notification {
    
    func keyboardSizeForView(view: UIView) -> CGRect? {
        var coords: CGRect? = nil
        
        let rawKeyboardRect = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        if let properlyRotatedCoords = view.window?.convert(rawKeyboardRect!, to: view) {
            coords = properlyRotatedCoords
        }
        
        return coords
    }
}

// MARK: -

extension NSNotification.Name {
    // Remove this
    static let JFSample = Notification.Name("Sample")
}

