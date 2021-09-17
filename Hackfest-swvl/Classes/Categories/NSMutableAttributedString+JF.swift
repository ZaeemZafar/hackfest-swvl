//
//  NSMutableAttributedString+JF.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 5/29/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.medium(fontSize: 14.0)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.normal(fontSize: 14.0)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        
        return self
    }
    
    @discardableResult func light(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.light(fontSize: 14.0)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        
        return self
    }
}
